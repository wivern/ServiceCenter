# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :spare_part do
    name "MyString"
  end
  factory :spare_part1, class: SparePart do
    part_number "F636-102-7410"
    name "EVF EYECUP"
  end
end
