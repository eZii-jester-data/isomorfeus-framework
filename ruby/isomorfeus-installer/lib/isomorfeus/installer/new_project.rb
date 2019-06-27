require 'opal-webpack-loader/installer_cli'
require 'opal-webpack-loader/version'

module Isomorfeus
  module Installer
    class NewProject
      attr_reader :installer

      def self.installer
        Isomorfeus::Installer
      end

      def self.execute(yarn_and_bundle: true)
        begin
          Dir.mkdir(installer.project_dir)
          Dir.chdir(installer.project_dir)
        rescue
          puts "Directory #{installer.project_dir} could not be created!"
          exit 1
        end

        root = Dir.open('.')

        begin
          Isomorfeus::Installer.create_directories
          Isomorfeus::Installer.install_framework

          OpalWebpackLoader::Installer::CLI.start(['iso'])

          Isomorfeus::Installer.install_styles
          Isomorfeus::Installer.install_js_entries
          Isomorfeus::Installer.install_isomorfeus_entries

          Isomorfeus::Installer.create_components
          Isomorfeus::Installer.create_spec

          Isomorfeus::Installer.create_package_json
          Isomorfeus::Installer.create_gemfile
          Isomorfeus::Installer.create_procfile

          if yarn_and_bundle
            puts 'Executing yarn install:'
            system('yarn install')
            puts 'Executing bundle install:'
            system('bundle install')
          end

          Dir.chdir('..')
          puts 'Installation finished, make your dreams come true :)'
        rescue Exception => e
          puts e.backtrace.join("\n")
          puts "Installation failed: #{e.message}"
        end
      end
    end
  end
end