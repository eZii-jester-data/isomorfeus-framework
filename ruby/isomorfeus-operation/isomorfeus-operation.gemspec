require_relative 'lib/isomorfeus/operation/version.rb'

Gem::Specification.new do |s|
  s.name         = 'isomorfeus-operation'
  s.version      = Isomorfeus::Operation::VERSION
  s.author       = 'Jan Biedermann'
  s.email        = 'jan@kursator.de'
  s.license      = 'MIT'
  s.homepage     = 'http://isomorfeus.com'
  s.summary      = 'Natural language operations for Isomorfeus.'
  s.description  = 'Write operations for Isomorfeus in your natural language.'

  s.files          = `git ls-files -- {lib,LICENSE,README.md}`.split("\n")
  # s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths  = ['lib']

  s.add_dependency 'activesupport', '~> 6.0'
  s.add_dependency 'oj', '>= 3.10.0'
  s.add_dependency 'opal', '>= 1.0.0'
  s.add_dependency 'opal-activesupport', '~> 0.3.3'
  s.add_dependency 'isomorfeus-react', '>= 16.12.1'
  s.add_dependency 'isomorfeus-redux', '~> 4.0.16'
  s.add_dependency 'isomorfeus-transport', Isomorfeus::Operation::VERSION
  s.add_development_dependency 'isomorfeus', Isomorfeus::Operation::VERSION
  s.add_development_dependency 'opal-webpack-loader', '>= 0.9.9'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.8.0'
end
