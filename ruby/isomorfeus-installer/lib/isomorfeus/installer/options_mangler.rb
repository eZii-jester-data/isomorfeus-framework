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

        if options.key?(:transport) && !options.key?(:transport_store)
          puts "A transport store (-s) is required when using a transport."
          exit 1
        elsif options.key?(:transport_store) && !options.key?(:transport)
          puts "A transport (-t) is required when using a transport store."
          exit 1
        end

        if options.key?(:transport_store)
          if installer.sorted_transport_stores.include?(options[:transport_store])
            installer.transport_store = installer.transport_stores[options[:transport_store]]&.fetch(:installer)
          else
            puts "Transport store #{options[:transport_store]} not available!"; exit 1
          end
        end

        if options.key?(:transport)
          if installer.sorted_transports.include?(options[:transport])
            installer.transport = installer.transports[options[:transport]]&.fetch(:installer)
          else
            puts "Transport #{options[:transport]} not available!"; exit 1
          end
        end

        if options.key?(:rack_server) && installer.sorted_rack_servers.include?(options[:rack_server])
          installer.rack_server = installer.rack_servers[options[:rack_server]]
        else
          installer.rack_server = installer.rack_servers['puma']
        end
      end
    end
  end
end