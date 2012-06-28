Gem::Specification.new do |s|
  s.name        = 'dashku'
  s.version     = '0.0.0'
  s.date        = '2012-06-28'
  s.summary     = "A wrapper to the Dashku API"
  s.description = "A wrapper to the Dashku API"
  s.authors     = ["Paul Jensen"]
  s.email       = 'admin@dashku.com'
  s.files       = ["lib/dashku.rb"]
  s.homepage    = 'https://dashku.com'
  s.add_runtime_dependency 'rspec', '>= 2.10.0'
  s.add_runtime_dependency 'httparty', '>= 0.8.3'
end