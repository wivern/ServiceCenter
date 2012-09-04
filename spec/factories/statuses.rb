FactoryGirl.define do
  factory :status do
    name Faker::Lorem.words 1
    trait :performed_status do
      ready true
      performed true
    end
  end
end