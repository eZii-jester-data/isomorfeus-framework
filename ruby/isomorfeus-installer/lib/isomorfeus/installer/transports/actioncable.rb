module Isomorfeus
  module Installer
    module Transports
      module ActionCable
        def self.install(root)
          # data_hash = { requires: Isomorfeus::Installer.create_requires }
          # Isomorfeus::Installer.create_file_from_template(File.join('actioncable', 'actioncable_ru.erb'), 'actioncable.ru', data_hash)
        end

        def self.config
          'ActionCable::Server::Base.config.logger = ActiveSupport::Logger.new(STDOUT)'
        end

        def self.js_import
          "import ActionCable from 'actioncable';"
        end

        def self.js_global
          "global.ActionCable = ActionCable;"
        end

        def self.rack_app
          'ActionCable.server'
        end

        def self.rack_app_mount_path
          'websocket'
        end

        def self.requires
          "require 'isomorfeus-transport-actioncable'"
        end
      end
    end
  end
end

Isomorfeus::Installer.add_transport_module('actioncable', {
  gems: [ { name: 'isomorfeus-transport', version: "~> #{Isomorfeus::Installer::VERSION}" },
          { name: 'isomorfeus-transport-actioncable', version: "~> #{Isomorfeus::Installer::VERSION}" } ],
  npms: [ { name: 'actioncable', version: '^5.2.2' } ],
  installer: Isomorfeus::Installer::Transports::ActionCable
})