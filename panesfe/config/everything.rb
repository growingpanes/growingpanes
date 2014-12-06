%W{
  controllers/application_controller
  controllers/root_controller

  models/user
  models/presentation
  models/presentation_item

}.each{|lib|require File.expand_path('../../'+lib, __FILE__)}
