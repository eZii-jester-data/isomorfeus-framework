require '../version.rb'

Gem::Specification.new do |s|
  s.name         = 'isomorfeus-vis'
  s.version      = Isomorfeus::VERSION
  s.author       = 'Jan Biedermann'
  s.email        = 'jan@kursator.de'
  s.homepage     = 'https://github.com/janbiedermann/isomorfeus-vis'
  s.summary      = 'A Opal Ruby wraper for Vis.js with a Isomorfeus Component.'
  s.description  = 'Write React Components in ruby to show graphics created with Vis.js in the ruby way'

  s.files          = `git ls-files`.split('\n')
  s.executables    = `git ls-files -- bin/*`.split('\n').map { |f| File.basename(f) }
  s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths  = ['lib']

  s.add_dependency 'opal', '>= 0.11.0'
  s.add_dependency 'opal-activesupport', '~> 0.3.3'
  s.add_dependency 'isomorfeus-react', '>= 16.9.2'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.8.0'
end
