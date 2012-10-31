class Docs::PrintsController < ApplicationController
  def print
    @report = Report.find_by_friendly_url(params[:report])
    @order = Order.find(params[:id])
    report = ODFReport::Report.new("#{RAILS_ROOT}/public/assets/#{@report.template_file}") do |r|
      # virtual attributes
      r.add_field(:complect, @order.complect)
      r.add_field(:diag_goal, @order.diag_goal)
      r.add_field(:defect, @order.defect)
      r.add_field(:external_state, @order.external_state)
      r.add_field(:internal_state, @order.internal_state)
      r.add_field(:activities_amount, @order.activities_amount)
      r.add_field(:spare_parts_amount, @order.spare_parts_amount)
      r.add_field(:total_amount, @order.total_amount)
      r.add_field(:discount_amount, @order.discount_amount)
      r.add_field(:total_amount_with_discount, @order.total_amount_with_discount)
      r.add_field(:responsible_name, current_person.organization.responsible.name_with_initials) if current_person.organization.responsible
      add_attributes(r, @order, '')
      add_attributes(r, current_person.organization, 'organization_')
      #@order.attributes.each { |attr, value|
      #  unless /^*_id$/ =~ attr
      #    if value && Order.columns_hash[attr.to_s].type == :date
      #      f_value = I18n.localize(value, :format => :medium)
      #    end
      #    f_value ||= value.to_s
      #    logger.debug "Adding field #{attr} with #{f_value}"
      #    r.add_field(attr, f_value)
      #  end
      #}
      @order.class.reflect_on_all_associations(:belongs_to).each { |ref|
        logger.debug "association #{ref.name}"
        add_reflection(r, ref, @order.send(ref.name)) unless ref.name.to_s == 'organization' }
      Organization.reflect_on_all_associations(:belongs_to).each{ |ref|
        add_reflection(r, ref, current_person.organization.send(ref.name))
      }
      #tables
      @order.class.reflect_on_all_associations(:has_many).each{ |ref|
        add_table(r, ref, @order.send(ref.name))
      }
    end
    report_file_name = report.generate
    send_file(report_file_name)
  end

  private

  def add_attributes(report, model, prefix)
    model.attributes.each{|attr, value|
      if value && model.class.columns_hash[attr.to_s].type == :date
        f_value = I18n.localize(value, :format => :medium)
      end
      f_value ||= value.to_s
      report.add_field("#{prefix}#{attr}", f_value)
    }
  end

  def add_table(report, ref, collection, options = { :header => true })
    logger.debug("adding table #{ref.name}")
    report.add_table(ref.name, collection, options) do |t|
      ref.klass.columns.each { |col|
        logger.debug("adding column #{col.name}")
        t.add_column col.name.to_sym, col.name.to_sym
      }
      #FIXIT hack to inject virtual attribute
      if ref.name.to_s == 'order_spare_parts'
        logger.debug "adding virtual column amount"
        t.add_column(:amount, :amount)
      end
      if ref.name.to_s == 'working_order_activities'
        logger.debug "adding virtual column activity_price"
        t.add_column(:activity_price_value, :price)
      end

      ref.klass.reflect_on_all_associations(:belongs_to).each{ |assoc|
        assoc.klass.columns.each {|col|
          logger.debug("adding column #{assoc.name}_#{col.name}")
          t.add_column("#{assoc.name}_#{col.name}".to_sym){ |item|
            #logger.debug "Call to #{assoc.name}.#{col.name}"
            assoc_v = item.send(assoc.name)
            assoc_v ? assoc_v.send(col.name) : '' }
        }
      }
    end
  end

  def add_reflection(report, reflection, data)
    reflection.klass.columns.each { |attr|
      field_name = "#{reflection.name}_#{attr.name}"
      if attr.name != 'id'
        if reflection.klass == Person and attr.name == 'name'
          value = data.name_with_initials if data
        else
          value = data.send("#{attr.name}") if data
        end
        if reflection.klass == Activity and attr.name == 'price'
          value = data.price.value if data
        end
        value ||= ''
        logger.debug "Adding field #{field_name} with #{value}"
        report.add_field(field_name, value)
      end
    }
    if data
      reflection.klass.reflect_on_all_associations.each{ |ref|
        logger.debug "Adding association #{ref.name}"
        unless ref.name.to_s == 'organization'
          add_reflection(report, ref, data.send(ref.name))  unless [:has_many, :has_and_belongs_to_many].include?(ref.macro) or ref.options.include?(:as)
        end
      }
    end
  end

end
