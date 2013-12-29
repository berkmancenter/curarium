json.array!(@sections) do |section|
  json.extract! section, :id, :users, :admins, :spotlights, :trays
  json.url section_url(section, format: :json)
end
