json.array!(@collections) do |collection|
  json.extract! collection, :id, :name, :key, :description, :approved, :configuration
  json.url collection_url(collection, format: :json)
end
