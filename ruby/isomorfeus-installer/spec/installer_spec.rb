require 'spec_helper'

RSpec.describe 'isomorfeus installer' do
  context 'creating a app' do
    before do
      Dir.chdir('spec')
      Dir.mkdir('test_apps') unless Dir.exist?('test_apps')
      Dir.chdir('test_apps')
      FileUtils.rm_rf('morphing') if Dir.exist?('morphing')
    end

    after do
      Dir.chdir('..') if Dir.pwd.end_with?('morphing')
      FileUtils.rm_rf('morphing') if Dir.exist?('morphing')
      Dir.chdir('..')
      Dir.chdir('..')
    end

    it 'it can' do
      Isomorfeus::Installer::CLI.start(%w[new morphing])
      Dir.chdir('morphing')
      expect(File.exist?(File.join('isomorfeus','styles', 'application.css'))).to be true
      expect(File.exist?(File.join('isomorfeus', 'imports', 'application.js'))).to be true
      expect(File.exist?(File.join('isomorfeus', 'imports', 'application_common.js'))).to be true
      expect(File.exist?(File.join('isomorfeus', 'imports', 'application_debug.js'))).to be true
      expect(File.exist?(File.join('isomorfeus', 'imports', 'application_ssr.js'))).to be true
      expect(File.exist?(File.join('isomorfeus', 'isomorfeus_loader.rb'))).to be true
      expect(File.exist?(File.join('owl_init.rb'))).to be true
      expect(File.exist?(File.join('app_loader.rb'))).to be true
      expect(File.exist?(File.join('webpack', 'debug.js'))).to be true
      expect(File.exist?(File.join('webpack', 'development.js'))).to be true
      expect(File.exist?(File.join('webpack', 'production.js'))).to be true
      expect(Dir.exist?(File.join('public', 'assets'))).to be true
      expect(File.exist?('package.json')).to be true
      expect(File.exist?('Procfile')).to be true
      expect(File.exist?('ProcfileDebug')).to be true
      expect(File.exist?('config.ru')).to be true
      expect(File.exist?('morphing_app.rb')).to be true
      expect(File.exist?('Gemfile')).to be true
    end

    it 'with the cmd it can' do
      `bundle exec isomorfeus new morphing`
      Dir.chdir('morphing')
      expect(File.exist?(File.join('isomorfeus','styles', 'application.css'))).to be true
      expect(File.exist?(File.join('isomorfeus', 'imports', 'application.js'))).to be true
      expect(File.exist?(File.join('isomorfeus', 'imports', 'application_common.js'))).to be true
      expect(File.exist?(File.join('isomorfeus', 'imports', 'application_debug.js'))).to be true
      expect(File.exist?(File.join('isomorfeus', 'imports', 'application_ssr.js'))).to be true
      expect(File.exist?(File.join('isomorfeus', 'isomorfeus_loader.rb'))).to be true
      expect(File.exist?(File.join('owl_init.rb'))).to be true
      expect(File.exist?(File.join('app_loader.rb'))).to be true
      expect(File.exist?(File.join('webpack', 'debug.js'))).to be true
      expect(File.exist?(File.join('webpack', 'development.js'))).to be true
      expect(File.exist?(File.join('webpack', 'production.js'))).to be true
      expect(Dir.exist?(File.join('public', 'assets'))).to be true
      expect(File.exist?('package.json')).to be true
      expect(File.exist?('Procfile')).to be true
      expect(File.exist?('ProcfileDebug')).to be true
      expect(File.exist?('config.ru')).to be true
      expect(File.exist?('morphing_app.rb')).to be true
      expect(File.exist?('Gemfile')).to be true
    end
  end

  context 'in a new app' do
    before :all do
      Dir.chdir('spec')
      Dir.mkdir('test_apps') unless Dir.exist?('test_apps')
      Dir.chdir('test_apps')
      FileUtils.rm_rf('morphing') if Dir.exist?('morphing')
      Isomorfeus::Installer::CLI.start(%w[new morphing])
      Dir.chdir('morphing')
      `env -i PATH=$PATH yarn install`
      `env -i PATH=$PATH bundle install`
    end

    after :all do
      Dir.chdir('..') if Dir.pwd.end_with?('morphing')
      FileUtils.rm_rf('morphing') if Dir.exist?('morphing')
      Dir.chdir('..')
      Dir.chdir('..')
    end

    it 'can bundle the assets' do
      `env -i PATH=$PATH yarn run production_build`
      manifest = Oj.load(File.read(File.join('public', 'assets', 'manifest.json')), mode: :strict)
      application_js = manifest['application.js']
      expect(File.exist?(File.join('public', application_js))).to be true
    end

    it 'can execute tests' do
      test_result = `env -i PATH="#{ENV['PATH']}" bundle exec rspec`
      expect(test_result).to include('1 example, 0 failures')
    end
  end
end