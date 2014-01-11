json.array!(@annotations) do |annotation|
  json.extract! annotation, :id, :record_id, :user_id, :content
  json.url annotation_url(annotation, format: :json)
end
