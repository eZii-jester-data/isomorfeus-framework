require '../version.rb'

Gem::Specification.new do |s|
  s.name         = 'isomorfeus-transport-pusher'
  s.version      = Isomorfeus::VERSION
  s.author       = 'Jan Biedermann'
  s.email        = 'jan@kursator.de'
  s.homepage     = 'http://isomorfeus.org'
  s.summary      = 'Driver for Pusher.com pub sub service for isomorfeus-transport for Isomorfeus.'
  s.description  = 'Driver for Pusher.com pub sub service for isomorfeus-transport for Isomorfeus.'

  s.files          = `git ls-files`.split("\n")
  s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths  = ['lib']

  s.add_runtime_dependency 'opal', '~> 0.11.0'
  s.add_runtime_dependency 'isomorfeus-transport', Isomorfeus::VERSION
end
