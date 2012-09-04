FactoryGirl.define do

  factory :producer do
    name Faker::Company.name
  end

  factory :product do
    name Faker::Lorem.words
    producer
  end
end