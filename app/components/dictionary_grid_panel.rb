class DictionaryGridPanel < Netzke::Basepack::GridPanel

  action :merge do
    {
        :text => I18n.t('views.actions.merge.text'),
        :tooltip => I18n.t('views.actions.merge.tooltip'),
        :icon => :arrow_merge
    }
  end

  js_mixin :dictionary_grid_panel
  js_translate *%w{:confirmation sure_to_merge_items}

  endpoint :merge_items do |params|
    logger.debug "Merge items options #{params.inspect}"
    items = ActiveSupport::JSON.decode(params[:items])
    model_class = config[:model].constantize
    model_class.merge_items(items) if model_class.respond_to?(:merge_items)
  end

  def default_bbar
    res = super
    res << "-" << :merge.action
    res
  end

end