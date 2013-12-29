json.array!(@records) do |record|
  json.extract! record, :id, :original, :parsed, :belongs_to
  json.url record_url(record, format: :json)
end
