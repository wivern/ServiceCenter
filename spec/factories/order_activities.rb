# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity do
    name Faker::Lorem.words 3
    sequence(:code){|n| "WS#{n}" }
    price (100..1000).to_a.sample
    score 10
    currency
  end

  factory :order_activity do
    activity
    performed_at Date.today
  end
end
