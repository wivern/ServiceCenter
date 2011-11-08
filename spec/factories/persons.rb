FactoryGirl.define do
  factory :person do
    name 'admin'
    email 'admin@pentar.ru'
    password 'Admin123'
  end
  factory :fail_person do
    name 'admin'
    password '123'
  end
end