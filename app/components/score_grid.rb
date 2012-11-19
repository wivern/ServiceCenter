#encoding: UTF-8
class ScoreGrid < Netzke::Basepack::GridPanel
  include ServiceCenter::Reportable

  def configuration
    @ability = Ability.new Netzke::Core.current_user
    super.tap do |s|
      #s[:title] = Person.model_name.human({:count => 5})
      s[:columns] = [
          {:name => :name},
          {:name => :username},
          {:name => :email},
          {:name => :scored_at}
      ]
      s[:prohibit_create] = true
      s[:prohibit_update] = true
      s[:prohibit_delete] = true
      s[:enable_edit_in_form] = false
      s[:scopes] = [[:in_current_organization]]
      if @ability.can? :print, :payments
        s[:tbar] = [
            {:text => 'Печать', :icon => :printer.icon, :name => :print, :menu => [:print_payments.action]},
            {:text => 'Месяц', :icon => :calendar.icon, :name => :month, :menu => [{:xtype => :datepicker, :name => :date}]}
        ]
      end
    end
  end

  js_mixin :score_grid

  action :print_payments do
    {
        :text => "Платежная ведомость",
        :icon => :coins
    }
  end

  endpoint :change_month do |params|
    logger.debug "Changing date to #{params[:date]}"
    if params[:date]
      component_session[:date] = params[:date]
    end
    {:set_result => "ok"}
  end

  def get_data(*args)
    params = args.first || {} # params are optional!
    if !config[:prohibit_read]
      {}.tap do |res|
        records = get_records(params)
        #data = records.map { |r| r.to_array(columns(:with_meta => true)) }
        data = score_to_array(records)
        logger.debug "Records: #{data.inspect}"
        logger.debug "Columns: #{columns}"
        res[:data] = data
        res[:total] = records.total_entries if config[:enable_pagination]

        # provide association values for all records at once
        # assoc_values = get_association_values(records, columns)
        # res[:set_association_values] = assoc_values.literalize_keys if assoc_values.present?
      end
    else
      flash :error => "You don't have permissions to read data"
      {:netzke_feedback => @flash}
    end
  end

  def score_to_array(records)
    records.map{|r|
      data = []
      columns.each{|col|
        if col[:name] == :scored_at
          data << r.scored_at(component_session[:date])
        else
          data << r.send(col[:name])
        end
      }
      data
    }
  end


end