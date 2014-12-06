#\ -w -p 3000
require_relative 'config/boot'

maps = {
  '/'                  => RootController,
}
maps.each do |path, controller|
  map(path){ run controller}
end
