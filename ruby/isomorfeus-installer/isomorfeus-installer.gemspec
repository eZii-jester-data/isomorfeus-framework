require '../version.rb'

Gem::Specification.new do |s|
  s.name         = 'isomorfeus-installer'
  s.version      = Isomorfeus::VERSION
  s.author       = 'Jan Biedermann'
  s.email        = 'jan@kursator.de'
  s.homepage     = 'http://isomorfeus.com'
  s.summary      = 'Create new isomorfeus-framework applications with ease.'
  s.description  = 'Create new isomorfeus-framework applications with ease.'

  s.bindir         = 'bin'
  s.executables    << 'isomorfeus'
  s.files          = `git ls-files`.split("\n")
  s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths  = ['lib']

  s.add_runtime_dependency 'activesupport', '~> 5.0'
end