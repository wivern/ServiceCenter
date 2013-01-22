# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :price, :class => 'Price' do
  end

  factory :price1_1, :class => "Price" do
    association :priceable, factory: :spare_part1
    association :organization, factory: :open_solutions, strategy: :build
    value 200
  end

  factory :price1_2, :class => "Price" do
    association :priceable, factory: :spare_part1
    association :organization, factory: :dominion, strategy: :build
    value 220
  end
end
