require_relative 'lib/isomorfeus/policy/version.rb'

Gem::Specification.new do |s|
  s.name         = 'isomorfeus-policy'
  s.version      = Isomorfeus::Policy::VERSION
  s.author       = 'Jan Biedermann'
  s.email        = 'jan@kursator.de'
  s.license      = 'MIT'
  s.homepage     = 'http://isomorfeus.com'
  s.summary      = 'Policies for Isomorfeus.'
  s.description  = 'Policies for Isomorfeus.'

  s.files          = `git ls-files -- {lib,LICENSE,README.md}`.split("\n")
  # s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths  = ['lib']

  s.add_dependency 'opal', '>= 1.0.0'
  s.add_dependency 'isomorfeus-react', '>= 16.12.1'
  s.add_dependency 'isomorfeus-redux', '~> 4.0.16'
  s.add_development_dependency 'isomorfeus', Isomorfeus::Policy::VERSION
  s.add_development_dependency 'opal-webpack-loader', '>= 0.9.9'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.8.0'
end
