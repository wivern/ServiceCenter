FactoryGirl.define do

  factory :person do
    name Faker::Name.name
    email Faker::Internet.email
    password 'Admin123'
    password_confirmation 'Admin123'
    organization
    position
  end
end