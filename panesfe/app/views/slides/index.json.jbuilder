# This is only used as a response to jquery.fileupload reqs
json.files @presentation.slides do |slide|
  json.extract! slide.image, :size
  json.url slide.image.url
  json.deleteUrl slide_url(slide)
  json.deleteType "DELETE"
#  json.thumbnailUrl slide.image.thumb.url
  json.name slide.image.filename
end
