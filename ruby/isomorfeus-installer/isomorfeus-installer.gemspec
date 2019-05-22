require '../version.rb'

Gem::Specification.new do |s|
  s.name         = 'isomorfeus-installer'
  s.version      = Isomorfeus::VERSION
  s.author       = 'Jan Biedermann'
  s.email        = 'jan@kursator.de'
  s.licenses     = %w[MIT]
  s.homepage     = 'http://isomorfeus.com'
  s.summary      = 'Create new isomorfeus-framework applications with ease.'
  s.description  = 'Create new isomorfeus-framework applications with ease.'
  s.bindir         = 'bin'
  s.executables    << 'isomorfeus'
  s.files          = `git ls-files -- {lib,LICENSE,readme.md}`.split("\n")
  # s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths  = ['lib']

  s.add_dependency 'activesupport', '~> 5.0'
  s.add_dependency 'oj', '>= 3.6.0'
  s.add_dependency 'opal-webpack-loader', '~> 0.8.3'
  s.add_dependency 'thor', '>= 0.19.4'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'roda', '~> 3.19.0'
  s.add_development_dependency 'rspec', '~> 3.8.0'
end