# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :amendment do
    previous ""
    amended ""
    user nil
    work nil
  end
end
