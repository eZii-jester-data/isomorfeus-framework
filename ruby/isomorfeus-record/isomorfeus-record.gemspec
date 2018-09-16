require '../version.rb'

Gem::Specification.new do |s|
  s.name         = 'isomorfeus-record'
  s.version      = Isomorfeus::VERSION
  s.author       = 'Jan Biedermann'
  s.email        = 'jan@kursator.de'
  s.homepage     = 'http://isomorfeus.org'
  s.summary      = 'Transparent Opal Ruby Data/Model Access from the browser for Isomorfeus'
  s.description  = "Write Browser Apps that transparently access server side models like 'MyModel.first_name', with ease"

  s.files          = `git ls-files`.split("\n")
  s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths  = ['lib']

  s.add_runtime_dependency 'activesupport', '~> 5.0'
  s.add_runtime_dependency 'oj', '~> 3.6.0'
  s.add_runtime_dependency 'opal', '~> 0.11.0'
  s.add_runtime_dependency 'opal-activesupport', '~> 0.3.1'
  s.add_runtime_dependency 'isomorfeus-component' , Isomorfeus::VERSION
  s.add_runtime_dependency 'isomorfeus-transport', Isomorfeus::VERSION
  s.add_development_dependency 'listen'
  s.add_development_dependency 'rake', '>= 11.3.0'
  s.add_development_dependency 'redis'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'yard', '~> 0.9.13'
end
