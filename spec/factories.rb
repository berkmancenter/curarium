FactoryGirl.define do
  factory :collection do
    factory :test_col do
      name 'test_col'
      description 'a generic, valid collection with a valid configuration & some records'
      approved true
      #admin test_user
      configuration '{"title":["title"],"image":["imageInfo","url"],"thumbnail":["imageInfo","thumbnail_url"],"artist":["artist"],"topics":["subject","*","topic",0]}'
    end

    factory :not_approved do
      name 'not_approved'
      description 'collection not yet approved'
      approved false
      #admin test_user
      configuration '{"title":["title"],"image":["imageInfo","url"],"thumbnail":["imageInfo","thumbnail_url"]}'
    end
  end

  factory :record do
    factory :starry_night do
      # collection test_col
      original '{"title":"Starry Night","imageInfo":{"url":"http://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg/1280px-Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg","thumbnail_url":"http://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg/116px-Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg"},"artist":"Van Gogh","subject":[{"topic":["stars"]},{"topic":["night"]},{"topic":["churches"]}]}'
    end

    factory :mona_lisa do
      # collection test_col
      original '{"title":"Mona Lisa","imageInfo":{"url":"http://upload.wikimedia.org/wikipedia/commons/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg","thumbnail_url":"http://upload.wikimedia.org/wikipedia/commons/thumb/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg/80px-Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg"},"artist":"da Vinci","subject":[{"topic":["Lisa"]},{"topic":["women"]},{"topic":["portraits"]}]}'
    end

    factory :last_supper do
      # collection test_col
      original '{"title":"Last Supper","imageInfo":{"url":"http://upload.wikimedia.org/wikipedia/commons/4/4b/%C3%9Altima_Cena_-_Da_Vinci_5.jpg","thumbnail_url":"http://upload.wikimedia.org/wikipedia/commons/thumb/6/62/%C3%9Altima_CenaII.jpg/120px-%C3%9Altima_CenaII.jpg"},"artist":"da Vinci","subject":[{"topic":["Jesus"]},{"topic":["Mary"]},{"topic":["men"]},{"topic":["supper"]},{"topic":["women"]},{"topic":["Joseph, Saint"]}]}'
    end

    factory :lucrezia do
      # collection test_col
      original '{"title":"Lucrezia","imageInfo":{"url":"http://upload.wikimedia.org/wikipedia/commons/d/d3/Parmigianino%2C_lucrezia_romana%2C_1540.jpg","thumbnail_url":"http://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Parmigianino%2C_lucrezia_romana%2C_1540.jpg/89px-Parmigianino%2C_lucrezia_romana%2C_1540.jpg"},"artist":"Parmigianino","subject":[{"topic":["death"]},{"topic":["women"]},{"topic":["breast"]}]}'
    end
  end

  factory :user do
    factory :test_user do
      name 'Test User'
      email 'test@example.com'
      password 't3stus3r'
      password_confirmation 't3stus3r'
    end
  end
end


