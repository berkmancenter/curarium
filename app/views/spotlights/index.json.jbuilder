json.array!(@spotlights) do |spotlight|
  json.extract! spotlight, :id, :title, :body, :type, :user, :updated_at
  json.url spotlight_url(spotlight, format: :json)
end
