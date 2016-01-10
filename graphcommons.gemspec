Gem::Specification.new do |s|
  s.name        = 'graphcommons'
  s.version     = '0.0.4'
  s.date        = '2016-01-09'
  s.summary     = "Ruby wrapper for Graphcommons API"
  s.description = "More info at: http://graphcommons.github.io/api-v1/"
  s.authors     = ["Yakup Cetinkaya"]
  s.email       = 'yakup.cetinkaya@gmail.com'
  s.files       = ["lib/graphcommons.rb"]
  s.homepage    = 'http://rubygems.org/gems/graphcommons'
  s.license     = 'GPL-3.0'
  s.platform = Gem::Platform.local
  s.add_runtime_dependency 'rest-client', '~> 1.8'
end
