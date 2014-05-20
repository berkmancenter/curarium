json.array!(@spotlights) do |spotlight|
  json.extract! spotlight, :id, :title, :body, :type, :user
  json.updated_at spotlight.updated_at.strftime("%d.%m.%y")
  json.url spotlight_url(spotlight, format: :json)
end
