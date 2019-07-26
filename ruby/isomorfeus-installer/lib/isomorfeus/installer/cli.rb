module Isomorfeus
  module Installer
    class CLI < Thor

      desc "new project_name", "create a new isomorfeus project with project_name"

      option :data, default: false, type: :boolean, aliases: '-d', desc: "Use data module. (optional, required by other modules)"
      option :i18n, default: false, type: :boolean, aliases: '-i', desc: "Use i18n module. (optional)"
      option :operation, default: false, type: :boolean, aliases: '-o', desc: "Use operation module. (optional)"
      option :policy, default: false, type: :boolean, aliases: '-p', desc: "Use policy module. (optional)"
      option :rack_server, default: 'iodine', aliases: '-r',
             desc: "Select rack server, one of: #{Isomorfeus::Installer.sorted_rack_servers.join(', ')}. (optional)"
      option :yarn_and_bundle, default: true, required: false, type: :boolean, aliases: '-y', desc: "Execute yarn install and bundle install. (optional)"
      def new(project_name)
        Isomorfeus::Installer.set_project_names(project_name)
        Isomorfeus::Installer.options = options
        Isomorfeus::Installer::NewProject.execute(yarn_and_bundle: options[:yarn_and_bundle])
      end
    end
  end
end
