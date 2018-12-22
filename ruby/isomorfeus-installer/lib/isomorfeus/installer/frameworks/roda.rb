module Isomorfeus
  module Installer
    module Frameworks
      module Roda
        def self.start_command
          'bundle exec puma'
        end

        def self.install(root)
          data_hash = { requires: Isomorfeus::Installer.create_requires,
                        script_tag: Isomorfeus::Installer.asset_bundler&.script_tag(Isomorfeus::Installer.entrypoint),
                        asset_bundler_includes: Isomorfeus::Installer.asset_bundler&.asset_bundler_includes,
                        asset_bundler_config: Isomorfeus::Installer.asset_bundler&.asset_bundler_config }

          Isomorfeus::Installer.create_file_from_template(File.join('roda', 'config_ru.erb'), 'config.ru', data_hash)
        end
      end
    end
  end
end

Isomorfeus::Installer.add_framework('roda', {
  gems: [ { name: 'roda', version: '~> 3.15.0' }, { name: 'puma', version: '~> 3.12.0' } ],
  installer: Isomorfeus::Installer::Frameworks::Roda,
  structure: :iso
})