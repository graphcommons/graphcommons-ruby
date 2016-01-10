Gem::Specification.new do |s|
  s.name        = 'graphcommons'
  s.version     = '0.0.5'
  s.date        = '2016-01-10'
  s.summary     = "Ruby wrapper for Graphcommons API"
  s.description = "Ruby wrapper for Graphcommons API. More info at: http://graphcommons.github.io/api-v1/"
  s.authors     = ["Yakup Cetinkaya"]
  s.email       = 'yakup.cetinkaya@gmail.com'
  s.files       = ["lib/graphcommons.rb"]
  s.homepage    = 'https://github.com/graphcommons/graphcommons-ruby'
  s.license     = 'GPL-3.0'
  s.platform = Gem::Platform.local
  s.add_runtime_dependency 'rest-client', '~> 1.8'
end
