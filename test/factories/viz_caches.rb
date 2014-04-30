# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :viz_cach, :class => 'VizCache' do
    query "MyText"
    data ""
  end
end
