%w{
  current_user
  i18n
  render
}.each do |lib|
  require_relative "#{lib}_helper"
end
