module ServiceCenter
  module ExtendedForm
    extend ActiveSupport::Concern

    included do
      alias_method_chain :normalize_field, :suggest

      endpoint :load_associated_data do |params|
        field = fields[params[:column].to_sym]
        record_id = params[:selected]
        {:set_result => load_assoc_record(field, record_id)}
      end

      endpoint :get_auto_suggest do |params|
        query = params[:query]

        field = fields[params[:column].to_sym]
        scope = field.to_options[:scope]
        query = params[:query]
        {:data => get_autosuggest_values(field, :query => query, :scope => scope, :record_id => params[:id])}
      end
    end

    module InstanceMethods
      def normalize_field_with_suggest(field)
        field = normalize_field_without_suggest(field)
        field[:parent_id] = self.global_id if [:autosuggest, :netzkeboxselect, :netzkepopupselect].include?(field[:xtype])

        field
      end

      protected

      def load_assoc_record(field, record_id)
        assoc, assoc_method = assoc_and_assoc_method_for_attr(field)
        if assoc
          relation = assoc.klass.scoped
          includes = all_association_syms(assoc)
          logger.debug("Associations " + includes.inspect)
          relation.includes(includes).find(record_id).to_json(:include => includes)
        end
      end

      def get_autosuggest_values(field, options = {})
        query = options[:query]
        assoc, assoc_method = nested_assoc_and_assoc_method_for_attr(field)
        if assoc
          # Options for an asssociation attribute

          relation = assoc.klass.scoped

          relation = relation.extend_with(options[:scope]) if options[:scope]

          if assoc.klass.column_names.include?(assoc_method)
            # apply query
            relation = relation.where("#{assoc_method} like ?", "#{query}%") if query.present?
            relation.all.map { |r| [r.id, r.send(assoc_method)] }
          else
            relation.all.map { |r| [r.id, r.send(assoc_method)] }.select { |id, value| value =~ /^#{query}/ }
          end
        end
      end

      def nested_assoc_and_assoc_method_for_attr(c)
        fields = c[:name].split('__')
        assoc, assoc_method = fields[-2, 2]
        if (assoc_method)
          assoc = data_class
          (fields - [assoc_method]).each { |i|
            if assoc.respond_to? :reflect_on_association
              assoc = assoc.reflect_on_association(i.to_sym)
            else
              assoc = Kernel.const_get(assoc.class_name).reflect_on_association(i.to_sym)
            end
          }
        end
        [assoc, assoc_method]
      end
    end
  end
end