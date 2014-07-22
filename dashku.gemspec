Gem::Specification.new do |s|
  s.name        = 'dashku'
  s.version     = '0.0.4'
  s.date        = '2014-07-22'
  s.summary     = "A wrapper to the Dashku API"
  s.description = "A wrapper to the Dashku API"
  s.authors     = ["Paul Jensen"]
  s.email       = 'admin@dashku.com'
  s.files       = ["lib/dashku.rb"]
  s.homepage    = 'https://dashku.com'
  s.add_runtime_dependency 'rspec', '>= 3.0.0'
  s.add_runtime_dependency 'httparty', '>= 0.13.1'
end