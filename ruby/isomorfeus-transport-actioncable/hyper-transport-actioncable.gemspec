require '../version.rb'

Gem::Specification.new do |s|
  s.name         = 'isomorfeus-transport-actioncable'
  s.version      = Isomorfeus::VERSION
  s.author       = 'Jan Biedermann'
  s.email        = 'jan@kursator.de'
  s.homepage     = 'http://isomorfeus.org'
  s.summary      = 'Driver for ActionCable pub sub for isomorfeus-transport for Isomorfeus.'
  s.description  = 'Driver for ActionCable pub sub for isomorfeus-transport for Isomorfeus.'

  s.files          = `git ls-files`.split("\n")
  s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths  = ['lib']

  s.add_runtime_dependency 'actioncable', '> 5.0.0'
  s.add_runtime_dependency 'opal', '~> 0.11.0'
  s.add_runtime_dependency 'isomorfeus-transport', Isomorfeus::VERSION
end
