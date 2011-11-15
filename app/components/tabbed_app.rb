class TabbedApp < Netzke::Basepack::AuthApp
  # To change this template use File | Settings | File Templates.
  def main_panel_config(overrides={})
    {
        :item_id => 'main_panel',
        :xtype => 'tabpanel',
        :region => 'center',
        :deferredRender => false,
        :autoScroll => true,
        :margins => '0 4 4 0',
        :activeTab => 0
        #:items => [{
        #               :id => 'tab1',
        #               :contentEl => 'tabs',
        #               :title => 'Main',
        #               :closable => false,
        #               :autoScroll => true
        #           }]
    }.merge(overrides)
  end

  js_mixin :tabbed_app
end