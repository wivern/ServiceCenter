class Numerator < ActiveRecord::Base
  belongs_to :repair_type

  def self::next_number(numerator_name = :number, order = nil)
    Numerator.transaction do
      if order.respond_to?(:repair_type)
        numerator = Numerator.find_or_create_by_name_and_repair_type_id(numerator_name, order.repair_type)
      else
        numerator = Numerator.find_or_create_by_name(numerator_name)
      end
      numerator.current_value = numerator.current_value + 1
      numerator.save
      numerator.current_value
    end
  end
end
