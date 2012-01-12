module Mergeable
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def acts_as_mergeable
      send :extend, MergeMethods
    end
  end

  module MergeMethods
    def merge_items(items=[])
      logger.debug("merging")
      self.transaction do
        #items = Complect.find_all_by_id(items)
        item = self.find(items.shift)

        conn = self.connection
        associations = self.reflect_on_all_associations
        associations.each { |assoc|
          logger.debug "Updating association #{assoc.inspect}"
          modified = 0
          case (assoc.macro)
            when :has_and_belongs_to_many
            then
              modified = conn.update_sql("UPDATE #{assoc.options[:join_table]} SET #{assoc.primary_key_name}=#{item.id} WHERE #{assoc.primary_key_name} IN (#{items.join(',')})")
            when :has_many
            then
              modified = conn.update_sql("UPDATE #{assoc.table_name} SET #{assoc.primary_key_name}=#{item.id} WHERE #{assoc.primary_key_name} IN (#{items.join(',')})")
          end
          logger.debug "#{modified} records was modified"
        }
        self.delete items
      end if items.size > 1
    end

    protected
    def foreign_key_for reflection
      return nil if !reflection
      return reflection.foreign_key if reflection.respond_to?(:foreign_key)
      return reflection.options[:foreign_key] if reflection.respond_to?(:options) and reflection.options.has_key?(:foreign_key)
      "#{reflection.name}_id"
    end
  end
end

ActiveRecord::Base.send :include, Mergeable