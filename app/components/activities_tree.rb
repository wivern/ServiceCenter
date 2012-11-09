#encoding: UTF-8
class ActivitiesTree < Netzke::Base
  js_base_class "Ext.tree.Panel"

  include Netzke::Basepack::DataAccessor

  js_mixin :activities_tree
  extend ActiveSupport::Memoizable

  js_property :root_visible, false

  def js_config #:nodoc:
    super.merge({
                    :model => config[:model],
                    :pri => data_class.primary_key
                })
  end

  endpoint :get_data do |params|
    if params[:node] == 'source'
      nodes = data_class.roots
    else
      nodes = data_class.where("parent_id = ?", params[:node])
    end
    nodes ||= []
    nodes.map{|n| {:text => n.name, :id => n.id}}
  end

end