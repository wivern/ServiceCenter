# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name Faker::Company.name
    city Faker::Address.city
    address Faker::Address.street_address
    phone Faker::PhoneNumber.phone_number
  end
end
