module Isomorfeus
  module Installer
    class CLI < Thor

      desc "new project_name", "create a new isomorfeus project with project_name"

      option :database, required: false, aliases: '-d',
             desc: "Select database, one of: #{Isomorfeus::Installer.sorted_databases.join(', ')}. (optional, requires transport)"
      option :i18n, default: false, type: :boolean, aliases: '-i', desc: "Use i18n module. (optional, requires transport)"
      option :operation, default: false, type: :boolean, aliases: '-o', desc: "Use operation module. (optional, requires transport)"
      option :policy, default: false, type: :boolean, aliases: '-p', desc: "Use policy module. (optional, requires transport)"
      option :rack_server, default: 'iodine', aliases: '-r',
             desc: "Select rack server, one of: #{Isomorfeus::Installer.sorted_rack_servers.join(', ')}. (optional)"
      option :transport, required: false, aliases: '-t',
             desc: "Select transport, one of: #{Isomorfeus::Installer.sorted_transports.join(', ')}. (optional if no other features that depend on a transport are used)"
      option :transport_store, required: false, aliases: '-e',
             desc: "Select transport store, one of: #{Isomorfeus::Installer.sorted_transport_stores.join(', ')}. (optional with no transport, required if a transport is used)"
      option :yarn_and_bundle, default: true, required: false, type: :boolean, aliases: '-y', desc: "Execute yarn install and bundle install. (optional)"
      def new(project_name)
        Isomorfeus::Installer.set_project_names(project_name)
        Isomorfeus::Installer.options = options
        Isomorfeus::Installer::NewProject.execute(yarn_and_bundle: options[:yarn_and_bundle])
      end
    end
  end
end
