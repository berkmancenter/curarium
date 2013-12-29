json.array!(@spotlights) do |spotlight|
  json.extract! spotlight, :id, :title, :body, :type, :records
  json.url spotlight_url(spotlight, format: :json)
end
