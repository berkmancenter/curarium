FactoryGirl.define do
  factory :collection do
    factory :test_col do
      name 'test_col'
      description 'a generic, valid collection with a valid configuration & some records'
      approved true
      configuration '{"title":["titleInfo",0,"title",0],"image":["relatedItem","*","content","location",0,"url",0,"content"],"thumbnail":["relatedItem","*","content","location",0,"url",1,"content"]}'
    end
  end
end


