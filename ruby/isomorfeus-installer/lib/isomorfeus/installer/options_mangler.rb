module Isomorfeus
  module Installer
    module OptionsMangler
      def self.installer
        Isomorfeus::Installer
      end

      def self.mangle_options(options)
        if options.key?(:database)
          if installer.sorted_databases.include?(options[:database])
            installer.database = installer.databases[options[:database]]&.fetch(:installer)
          else
            puts "Database #{options[:database]} not available!"; exit 1
          end
        end

        if options.key?(:rack_server) && installer.sorted_rack_servers.include?(options[:rack_server])
          installer.rack_server = installer.rack_servers[options[:rack_server]]
          installer.rack_server_name = options[:rack_server]
        else
          installer.rack_server = installer.rack_servers['iodine']
        end
      end
    end
  end
end