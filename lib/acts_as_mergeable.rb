module Mergeable
  extend ActiveSupport::Concern

  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def acts_as_mergeable(options={})
      send :extend, MergeMethods
      cattr_accessor :split_on_field
      self.split_on_field = (options[:split_on] || :name).to_s
      cattr_accessor :split_regexp
      self.split_regexp = options[:split_regexp] || /[\.,]/
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
              table = assoc.options[:join_table]
              pk = assoc.primary_key_name
              fk = assoc.association_foreign_key
              conn.execute("DELETE FROM #{table} t1 WHERE #{pk} IN (#{items.join(",")}) AND EXISTS(SELECT * FROM #{table} WHERE #{pk} = #{item.id} AND  t1.#{fk} = #{fk})")
              clean_items = items.dup
              while(clean_items.size > 1)
                item_id = clean_items.pop
                conn.execute("DELETE FROM #{table} t1 WHERE #{pk} IN (#{clean_items.join(",")}) AND EXISTS(SELECT * FROM #{table} WHERE #{pk} = #{item_id} AND  t1.#{fk} = #{fk})")
              end
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

    #def split_item(item = nil)
    #  if item
    #    logger.debug("splitting")
    #    self.transaction do
    #      item = self.find(item) unless item.kind_of? ActiveRecord::Base
    #      branched = []
    #      branch_names = item.send(self.split_on_field.to_sym).split(self.split_regexp).each(&:strip!)
    #      branch_names.each { |name|
    #        logger.debug "creating #{name}"
    #        branch = item.clone
    #        branch.send("#{self.split_on_field}=".to_sym, name)
    #        branch.save
    #        branched << branch
    #      }
    #      associations = self.reflect_on_all_associations
    #      associations.each { |assoc|
    #        case assoc.macro
    #          when :has_and_belongs_to_many
    #            then
    #            collection = item.send(assoc.name)
    #        end
    #      }
    #    end
    #  end
    #end

    protected
    def foreign_key_for reflection
      return nil if !reflection
      return reflection.foreign_key if reflection.respond_to?(:foreign_key)
      return reflection.options[:foreign_key] if reflection.respond_to?(:options) and reflection.options.has_key?(:foreign_key)
      "#{reflection.name.to_s.singularize}_id"
    end
  end
end

ActiveRecord::Base.send :include, Mergeable