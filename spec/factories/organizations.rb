# encoding: UTF-8
# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name Faker::Company.name
    city Faker::Address.city
    address Faker::Address.street_address
    phone Faker::PhoneNumber.phone_number
  end
  factory :open_solutions, class:  Organization do
    id 7
    name "Открытые Решения"
  end
  factory :dominion, class: Organization do
    id 8
    name "Доминион-Электроникс"
  end
end
