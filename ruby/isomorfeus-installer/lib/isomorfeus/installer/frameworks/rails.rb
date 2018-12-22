module Isomorfeus
  module Installer
    module Frameworks
      module Rails
        VERSION = '~> 5.2.2'

        def self.start_command
          'bundle exec rails s'
        end

        def self.create_project(name)
          # make sure rails gem is installed, install if not
          gem_dependency = Gem::Dependency.new('rails', VERSION)
          rails_gem = gem_dependency.matching_specs.max_by(&:version)
          unless rails_gem
            puts "Installing rails"
            result = system('gem', 'install', 'rails', '-v', VERSION)
            unless result
              puts "Installation of rails failed! Exiting."
              exit 1
            end
          end
          # create new rails project
          result = system('rails', 'new', name, '--skip-sprockets', '--skip-bundle', '--skip-yarn')
          unless result
            puts "Creation of rails project failed! Exiting."
            exit 1
          end
        end

        def self.install(root)
          # config/routes.rb
          File.delete(File.join('config', 'routes.rb'))
          result = File.read(File.join(Isomorfeus::Installer.templates_path, 'rails', 'routes.rb'))
          File.write(File.join('config', 'routes.rb'), result)

          # config/initializers/assets.rb
          data_hash = { asset_bundler_config: Isomorfeus::Installer.asset_bundler&.asset_bundler_config }
          Isomorfeus::Installer.create_file_from_template(File.join('rails', 'assets.rb.erb'),
                                                          File.join('config', 'initializers', 'assets.rb'), data_hash)

          # app/helpers/application_helper.rb
          File.delete(File.join('app','helpers', 'application_helper.rb'))
          data_hash = { asset_bundler_includes: Isomorfeus::Installer.asset_bundler&.asset_bundler_includes(true) }
          Isomorfeus::Installer.create_file_from_template(File.join('rails', 'application_helper.rb.erb'),
                                                          File.join('app', 'helpers', 'application_helper.rb'), data_hash)

          # app/views/layouts/application.html.erb
          File.delete(File.join('app','views', 'layouts', 'application.html.erb'))
          result = File.read(File.join(Isomorfeus::Installer.templates_path, 'rails', 'application.html.erb.head'))
          result << "    <%= #{Isomorfeus::Installer.asset_bundler.script_tag('application.js')} %>\n"
          result << File.read(File.join(Isomorfeus::Installer.templates_path, 'rails', 'application.html.erb.tail'))
          File.write(File.join('app','views', 'layouts', 'application.html.erb'), result)

          # app/controllers/application_controller.rb
          File.delete(File.join('app', 'controllers', 'application_controller.rb'))
          result = File.read(File.join(Isomorfeus::Installer.templates_path, 'rails', 'application_controller.rb'))
          File.write(File.join('app', 'controllers' , 'application_controller.rb'), result)

          # app/views/application/index.html
          Dir.mkdir(File.join('app', 'views', 'application'))
          result = File.read(File.join(Isomorfeus::Installer.templates_path, 'rails', 'index.html'))
          File.write(File.join('app', 'views', 'application', 'index.html'), result)

          # app/assets/javascript/application.js
          File.rename(File.join('app', 'assets', 'javascripts', 'application.js'),
                      File.join('app', 'assets', 'javascripts', 'application.js_orig'))
        end
      end
    end
  end
end

Isomorfeus::Installer.add_framework('rails', {
  gems: :has_gemfile,
  installer: Isomorfeus::Installer::Frameworks::Rails,
  structure: :app_iso
})