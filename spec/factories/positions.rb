#encoding: UTF-8
# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :position do
    name Faker::Lorem.words 2
  end

  factory :inspector, :class => Position do
    name "Приемщик"
    roles [:inspector]
  end

  factory :brigadir, :class => Position do
    name "Бригадир"
    roles [:manager, :analyst]
  end

end
