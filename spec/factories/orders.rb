FactoryGirl.define do
  factory :repair_type do
    name Faker::Lorem.words 2
  end

  factory :currency do
    name "Rouble"
    full_name "Russian rouble"
    char_code 'RUR'
    num_code 849
  end

  factory :customer do
    address "#{Faker::Address.city},#{Faker::Address.street_address}"
    name Faker::Name.name
    email Faker::Internet.email
    phone Faker::PhoneNumber.phone_number
  end

  factory :product_passport do
    product
    producer
    factory_number "AB#{(10000..99999).to_a.sample}"
  end

  factory :complect do
    name Faker::Lorem.words
  end

  factory :external_state do
    name Faker::Lorem.words
  end

  factory :defect do
    name Faker::Lorem.words
  end

  factory :order do |order|
    repair_type
    customer
    product_passport
    ignore do
      complects_count 3
      external_states_count 2
      defects_count 3
    end
    order.complects{|o| [o.association(:complect)]}
    order.external_states{|o| o.build_list(:external_state, 3)}
    order.defects{|o| o.build_list(:defect, 5)}

    #before(:create) do |order, evaluator|
    #  FactoryGirl.build_list(:complect, evaluator.complects_count)
    #  FactoryGirl.build_list(:external_state, evaluator.external_states_count)
    #  FactoryGirl.build_list(:defect, evaluator.defects_count)
    #end
  end
  factory :performed_order, :parent => :order do |order|
    order.association :status, :performed_status
    work_performed_at Date.today
    ignore do
      activities_count 5
    end
    after(:create) do |order, evaluator|
      FactoryGirl.create_list :order_activity, evaluator.activities_count, order: order
    end
  end
end