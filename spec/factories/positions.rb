# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :position do
    name Faker::Lorem.words 2
  end
end
