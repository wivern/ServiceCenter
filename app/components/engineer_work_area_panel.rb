#encoding: UTF-8
class EngineerWorkAreaPanel < Netzke::Basepack::TabPanel

  component :diagnostic_panel do
    {
        :class_name => "Maintenance::DiagnosticPanel"
    }
  end

  component :maintenance_panel do
    {
        :class_name => "Maintenance::MaintenancePanel"
    }
  end

  def configuration
    super.tap do |c|
      c[:items] = [
          :diagnostic_panel.component(:title => "Диагностика"),
          :maintenance_panel.component(:title => "Ремонт")
      ]
    end
  end

end