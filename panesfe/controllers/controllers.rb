%w{
  application
  root
  auth
  presentations
}.each do |lib|
  require_relative "#{lib}_controller"
end
