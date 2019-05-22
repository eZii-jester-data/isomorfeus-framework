module Isomorfeus
  module Installer
    module TransportStores
      module Redis

      end
    end
  end
end

Isomorfeus::Installer.add_transport_store_module('redis', {
  gems: [ { name: 'isomorfeus-transport-store-redis', version: "~> #{Isomorfeus::Installer::VERSION}" } ],
  installer: Isomorfeus::Installer::TransportStores::Redis
})