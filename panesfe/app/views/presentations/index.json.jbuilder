json.array!(@presentations) do |presentation|
  json.extract! presentation, :id, :name, :published, :user_id
  json.url presentation_url(presentation, format: :json)
end
