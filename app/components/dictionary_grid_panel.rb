class DictionaryGridPanel < Netzke::Basepack::GridPanel
  action :merge do
    {
        :text => I18n.t('views.actions.merge.text'),
        :tooltip => I18n.t('views.actions.merge.tooltip')
    }
  end
end