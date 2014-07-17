Gem::Specification.new do |s|
  s.name        = 'dashku'
  s.version     = '0.0.3'
  s.date        = '2014-07-17'
  s.summary     = "A wrapper to the Dashku API"
  s.description = "A wrapper to the Dashku API"
  s.authors     = ["Paul Jensen"]
  s.email       = 'admin@dashku.com'
  s.files       = ["lib/dashku.rb"]
  s.homepage    = 'https://dashku.com'
  s.add_runtime_dependency 'rspec', '>= 2.12.0'
  s.add_runtime_dependency 'httparty', '>= 0.9.0'
end