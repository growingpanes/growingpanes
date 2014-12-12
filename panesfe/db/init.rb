DataMapper::Property::String.length(255)

case settings.environment
  when :development then DataMapper.setup(:default, "sqlite3://" + File.join(settings.root, 'db', "panesfe_development.db"))
  when :production  then DataMapper.setup(:default, "sqlite3://" + File.join(settings.root, 'db', "panesfe_production.db"))
  when :test        then DataMapper.setup(:default, "sqlite3://" + File.join(settings.root, 'db', "panesfe_test.db"))
end
