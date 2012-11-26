FactoryGirl.define do

  factory :person do
    name Faker::Name.name
    email Faker::Internet.email
    password 'Admin123'
    password_confirmation 'Admin123'
    organization
    factory :inspector_person do
      association :position, :factory => :inspector
    end
    factory :brigadir_person do
      association :position, :factory => :brigadir
    end
  end


end