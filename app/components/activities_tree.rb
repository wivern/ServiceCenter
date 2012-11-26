#encoding: UTF-8
class ActivitiesTree < Netzke::Base
  js_base_class "Ext.tree.Panel"

  include Netzke::Basepack::DataAccessor

  js_mixin :activities_tree
  extend ActiveSupport::Memoizable

  js_property :root_visible, false

  action :new_top_folder do
    {
        :text => "Создать раздел",
        :icon => :add
    }
  end

  action :new_folder do
    {
        :text => "Создать категорию",
        :icon => :folder_add
    }
  end

  action :delete do
    {
        :text => "Удалить",
        :icon => :delete
    }
  end

  action :refresh do
    {
        :text => "Обновить",
        :icon => :arrow_refresh
    }
  end

  def js_config #:nodoc:
    super.merge({
                    :model => config[:model],
                    :pri => data_class.primary_key,
                    :context_menu => config.has_key?(:context_menu) ? config[:context_menu] : default_context_menu
                })
  end

  endpoint :get_data do |params|
    if params[:node] == 'source'
      nodes = data_class.roots
    else
      nodes = data_class.where("parent_id = ?", params[:node].to_i)
    end
    nodes ||= []
    nodes.map!{|n| {:text => n.name, :id => n.id}}
    nodes << {:text => "Диагностика", :id => "scd", :icon_cls => "icon-fld-tool"} << {:text => "Все", :id => "all", :icon_cls => "icon-fld-all"} if params[:node] == 'source'
    nodes
  end

  endpoint :new_top_folder do |params|
    logger.debug "New category: #{params[:name]}"
    new_category params[:name]
  end

  endpoint :new_folder do |params|
    logger.debug "New folder: #{params.inspect}"
    new_category params[:name], params[:parent]
  end

  endpoint :remove_folder do |params|
    logger.debug "Remove folder: #{params.inspect}"
    remove_category params[:folder_id]
  end

  protected

  def new_category(name, parent_id = nil)
    parent = nil
    parent = ActivityCategory.find(parent_id) if parent_id
    folder = ActivityCategory.new(:name => name)
    if folder.save
      folder.move_to_child_of(parent) if parent
      {:netzke_feedback => "Раздел создан", :set_result => true}
    else
      folder.errors.to_a.each{|msg|
        flash :error => msg
      }
      {:netzke_feedback => @flash}
    end
  end

  def remove_category(category_id)
    folder = ActivityCategory.find(category_id)
    if folder.delete
      {:netzke_feedback => "Категория удалена", :set_result => true}
    else
      folder.errors.to_a.each{|msg| flash :error => msg}
      {:netzke_feedback => @flash}
    end
  end

  def default_context_menu
    res = []
    if config[:editable]
      %w{ new_top_folder new_folder }.map(&:to_sym).map(&:action).each{|item| res << item }
      res << "-" << :delete.action << "-"
    end
    res << :refresh.action
    res
  end

end