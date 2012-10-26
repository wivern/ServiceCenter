module ServiceCenter
  module ActsAsPriceable

    def self.included(base)
      base.extend ActsAsMethod
    end

    module ActsAsMethod
      def acts_as_priceable
        has_one :price, :as => :priceable,
                   :conditions => proc{["prices.organization_id = ?", Netzke::Core.current_user.organization]}
        has_many :prices, :as => :priceable, :extend => ServiceCenter::ActsAsPriceable::AssociationMethods
        class_eval <<-END
          include ServiceCenter::ActsAsPriceable::InstanceMethods
        END
      end
    end

    module ClassMethods

    end

    module InstanceMethods

      def self.included(base)
        base.extend ServiceCenter::ActsAsPriceable::ClassMethods
      end
      def price_id
        self.price.object_id
      end
    end

    module AssociationMethods
      def for_organization(organization)
        where("organization_id = ?", organization).first
      end
    end

  end
end

ActiveRecord::Base.send(:include, ServiceCenter::ActsAsPriceable)