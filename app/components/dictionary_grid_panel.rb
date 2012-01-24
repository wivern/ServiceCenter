class DictionaryGridPanel < Netzke::Basepack::GridPanel

  action :merge do
    {
        :text => I18n.t('views.actions.merge.text'),
        :tooltip => I18n.t('views.actions.merge.tooltip'),
        :icon => :arrow_merge
    }
  end

  action :split do
    {
        :text => I18n.t('views.actions.split.text'),
        :tooltip => I18n.t('views.actions.split.tooltip'),
        :icon => :arrow_branch
    }
  end

  js_mixin :dictionary_grid_panel
  js_translate *%w{:confirmation sure_to_merge_items sure_to_split_item}

  endpoint :merge_items do |params|
    logger.debug "Merge items options #{params.inspect}"
    items = ActiveSupport::JSON.decode(params[:items])
    model_class = config[:model].constantize
    model_class.merge_items(items) if model_class.respond_to?(:merge_items)
  end

  endpoint :split_item do |params|
    item_id = params[:item]
    model_class = config[:model].constantize
    item = model_class.find(item_id)
    model_class.split_item(item) if model_class.respond_to?(:split_item)
  end

  def default_bbar
    res = super
    res << "-" << :merge.action if @ability.can?(:merge, config[:model].constantize)
    res
  end

  def configuration
    @ability = Ability.new Netzke::Core.current_user
     super.tap do |c|
        c[:prohibit_create] = @ability.cannot?(:create, c[:model].constantize)
        c[:prohibit_update] = @ability.cannot?(:update, c[:model].constantize)
    end
  end

end