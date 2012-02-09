#encoding: UTF-8
class AnalyserForm < Netzke::Base
  js_base_class "Ext.form.Panel"

  js_mixin :analyser_form

  js_include :combo

  action :apply do
    {
        :text => I18n.t('netzke.basepack.form_panel.actions.apply'),
        :tooltip => I18n.t('netzke.basepack.form_panel.actions.apply_tooltip'),
        :icon => :tick
    }
  end

  def configuration
    super.tap do |sup|
      configure_bbar(sup)
      sup[:title] = I18n.t('analyser_form.title')
      sup[:items] = normalize_fields [
          {:field_label => Organization.human_name, :name => :organization, :model => :organization, :xtype => :scremotecombo},
          {:field_label => "Начальная дата", :name => :starting_date, :xtype => :datefield },
          {:field_label => "Конечная дата", :name => :finish_date, :xtype => :datefield},
          {:field_label => RepairType.human_name, :name => :repair_type, :model => :repair_type, :xtype => :scremotecombo},
          {:field_label => Status.human_name, :name => :status, :model => :status, :xtype => :scremotecombo},
          {:field_label => Producer.human_name, :name => :producer, :model => :producer, :xtype => :scremotecombo},
          {:field_label => "Менеджер", :name => :manager, :model => :person, :xtype => :scremotecombo},
          {:field_label => "Сервис-инженер", :name => :engineer, :scope => :active, :model => :person, :xtype => :scremotecombo}
      ]
    end
  end

  def configure_bbar(c)
    c[:bbar] = [:apply.action] if c[:bbar].nil?
  end

  endpoint :get_combobox_options do |params|
    model = params[:model].camelize.constantize
    relation = model.scoped
    relation = relation.send(params[:scope]) if params[:scope]
    relation = relation.order(:name)
    {:data => [[-1, 'Все']].concat(relation.map{|f| [f.id, f.name]})}
  end

  endpoint :netzke_submit, :pre => true do |params|
    netzke_submit params
  end

  protected

  def netzke_submit(params)
    data = ActiveSupport::JSON.decode(params[:data])
    session[:analysis_data] = data
    {:set_result => true}
  end

  def normalize_fields(fields = [])
    fields.each{|f|
      f[:parent_id] = self.global_id if f[:xtype] == :scremotecombo
    }
  end

end