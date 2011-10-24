class WideFormWindow < Netzke::Basepack::GridPanel::RecordFormWindow
  config :width => 780,
    :modal => true,
    :auto_height => true,
    :fbar => [:ok.action, :cancel.action]

end