module Isomorfeus
  module Installer
    module AssetBundlers
      module OpalWebpackLoader
        TARGETS = %w[development.js production.js]

        def self.start_command
          'yarn run start'
        end

        def self.script_tag(path)
          "owl_script_tag('#{path}')"
        end

        def self.package_scripts
          <<~SCRIPTS
          "scripts": {
            "start": "bundle exec opal-webpack-compile-server start webpack-dev-server --config #{development_js_path}",
            "build": "bundle exec opal-webpack-compile-server start webpack --config=#{production_js_path}"
          },
          SCRIPTS
        end

        def self.development_js_path
          if Isomorfeus::Installer.structure == :app_iso
            File.join('config', 'webpack', 'development.js')
          else
            'development.js'
          end
        end

        def self.production_js_path
          if Isomorfeus::Installer.structure == :app_iso
            File.join('config', 'webpack', 'production.js')
          else
            'production.js'
          end
        end

        def self.asset_bundler_config
          <<~CONFIG
          # OpalWebpackLoader.manifest_path = File.join( 'public', 'assets', 'manifest.json')
          if ENV['PROJECT_ENV'] && ENV['PROJECT_ENV'] != 'development'
            OpalWebpackLoader.client_asset_path = '' # the full path is in the manifest already, like: /packs/website_packs-97fd9c2b7e7bdb112fc1.js
            OpalWebpackLoader.use_manifest = true
          else
            OpalWebpackLoader.client_asset_path = 'http://localhost:3035/assets/'
            OpalWebpackLoader.use_manifest = false
          end
          CONFIG
        end

        def self.asset_bundler_includes(rails_style = false)
          if rails_style
            "include OpalWebpackLoader::RailsViewHelper"
          else
            "include OpalWebpackLoader::ViewHelper"
          end
        end

        def self.install(root)
          if Isomorfeus::Installer.structure == :iso
            entrypoint_path = Isomorfeus::Installer.entrypoint_path
            asset_output_path = Isomorfeus::Installer.asset_output_path
            isomorfeus_path = Isomorfeus::Installer.isomorfeus_path
            stylesheets_path = Isomorfeus::Installer.stylesheets_path
          else
            entrypoint_path = File.join('..', '..', Isomorfeus::Installer.entrypoint_path)
            asset_output_path = File.join('..', '..', Isomorfeus::Installer.asset_output_path)
            isomorfeus_path = File.join('..', '..', Isomorfeus::Installer.isomorfeus_path)
            stylesheets_path = File.join('..', '..', Isomorfeus::Installer.stylesheets_path)
          end

          data_hash = { isomorfeus_path: isomorfeus_path,
                        asset_output_path: asset_output_path,
                        stylesheets_path: stylesheets_path,
                        entrypoint_path: entrypoint_path}

          if Isomorfeus::Installer.structure == :app_iso
            Dir.mkdir('config') unless Dir.exist?('config')
            Dir.mkdir(File.join('config','webpack')) unless Dir.exist?(File.join('config', 'webpack'))
            TARGETS.each do |target|
              Isomorfeus::Installer.create_file_from_template(File.join('owl', target + '.erb'),
                                                              File.join('config', 'webpack', target), data_hash)
            end
          else
            TARGETS.each do |target_path|
              Isomorfeus::Installer.create_file_from_template(File.join('owl', target_path + '.erb'),
                                                              target_path, data_hash)
            end
          end
        end
      end
    end
  end
end

Isomorfeus::Installer.add_asset_bundler('owl', {
  gems: [ { name: 'opal-webpack-loader', version: '~> 0.5.0' } ],
  npms: [ { name: 'opal-webpack-loader', version: '^0.5.0' } ],
  installer: Isomorfeus::Installer::AssetBundlers::OpalWebpackLoader,
  structure: :iso
})