module Isomorfeus
  module Installer
    module OptionsMangler
      def self.mangle_options(options)
        if options.key?(:rack_server) && Isomorfeus::Installer.sorted_rack_servers.include?(options[:rack_server])
          Isomorfeus::Installer.rack_server = Isomorfeus::Installer.rack_servers[options[:rack_server]]
          Isomorfeus::Installer.rack_server_name = options[:rack_server]
        else
          Isomorfeus::Installer.rack_server = Isomorfeus::Installer.rack_servers['iodine']
        end
      end
    end
  end
end