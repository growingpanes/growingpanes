json.array!(@slides) do |slide|
  json.extract! slide, :id, :name, :published, :user_id
  json.url presentation_url(presentation, format: :json)
end
