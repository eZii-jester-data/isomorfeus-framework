# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib/', __FILE__)
require '../version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'isomorfeus-component'
  spec.version       = Isomorfeus::VERSION

  spec.authors       = ['David Chang', 'Adam Jahn', 'Mitch VanDuyn', 'Jan Biedermann']
  spec.email         = ['mitch@catprint.com', 'jan@kursator.com']
  spec.homepage      = 'http://isomorfeus.org'
  spec.summary       = 'Components for Isomorfeus using React.'
  spec.license       = 'MIT'
  spec.description   = 'Write React UI components in pure Ruby.'

  spec.files         = `git ls-files`.split("\n").reject { |f| f.match(%r{^(gemfiles|spec)/}) }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.require_paths = ['lib']

  spec.add_dependency 'isomorfeus-store', Isomorfeus::VERSION
  spec.add_dependency 'opal', '>= 0.11.0', '< 0.12.0'
  spec.add_dependency 'opal-activesupport', '~> 0.3.1'
  spec.add_dependency 'opal-browser', '~> 0.2.0'
  spec.add_dependency 'oj', '~> 3.6.0'

  spec.add_development_dependency 'listen'
  spec.add_development_dependency 'mime-types'
  spec.add_development_dependency 'nokogiri'
  spec.add_development_dependency 'puma'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop', '~> 0.51.0'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'timecop', '~> 0.8.1'
end
