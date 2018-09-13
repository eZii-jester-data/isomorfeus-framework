require '../version.rb'

Gem::Specification.new do |s|
  s.name         = 'isomorfeus-transport-store-redis'
  s.version      = Isomorfeus::VERSION
  s.author       = 'Jan Biedermann'
  s.email        = 'jan@kursator.de'
  s.homepage     = 'http://isomorfeus.org'
  s.summary      = 'Subscriptions store for isomorfeus-transport for Isomorfeus.'
  s.description  = 'Subscriptions store for isomorfeus-transport for Isomorfeus.'

  s.files          = `git ls-files`.split("\n")
  s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths  = ['lib']

  s.add_runtime_dependency 'isomorfeus-transport', Isomorfeus::VERSION
  s.add_runtime_dependency 'redis', '~> 4.0.1'
end
