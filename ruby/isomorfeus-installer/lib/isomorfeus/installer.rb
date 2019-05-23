module Isomorfeus
  module Installer
    # driver support

    def self.add_database(name, props)
      databases[name] = props
    end

    def self.add_i18n_module(name, props)
      i18ns[name] = props
    end

    def self.add_operation_module(name, props)
      operations[name] = props
    end

    def self.add_policy_module(name, props)
      policies[name] = props
    end

    def self.add_rack_server(name, props)
      rack_servers[name] = props
    end

    def self.add_transport_module(name, props)
      transports[name] = props
    end

    def self.add_transport_store_module(name, props)
      transport_stores[name] = props
    end

    class << self
      # application options
      attr_reader   :app_class
      attr_reader   :app_require
      attr_reader   :component_name
      attr_accessor :database
      attr_accessor :framework
      attr_accessor :i18n
      attr_accessor :operation
      attr_accessor :policy
      attr_reader   :project_dir
      attr_reader   :project_env
      attr_reader   :project_name
      attr_accessor :rack_server
      attr_accessor :rack_server_name
      attr_accessor :transport
      attr_accessor :transport_store

      # installer options
      attr_reader :options
    end

    def self.set_project_names(pro_dir)
      @project_dir    = pro_dir
      @project_name   = pro_dir.underscore
      @app_class      = @project_name.camelize + 'App'
      @app_require    = @project_name + '_app'
      @component_name = @app_class + 'Component'
      @project_env    = @project_name.upcase + '_ENV'
    end

    def self.options=(options)
      Isomorfeus::Installer::OptionsMangler.mangle_options(options)
      @options = options
    end

    def self.sorted_databases
      databases.keys.sort
    end

    def self.sorted_i18ns
      i18ns.keys.sort
    end

    def self.sorted_operations
      operations.keys.sort
    end

    def self.sorted_policies
      policies.keys.sort
    end

    def self.sorted_rack_servers
      rack_servers.keys.sort
    end

    def self.sorted_transports
      transports.keys
    end

    def self.sorted_transport_stores
      transport_stores.keys
    end

    def self.databases
      @databases ||= {}
    end

    def self.i18ns
      @i18ns ||= {}
    end

    def self.operations
      @operations ||= {}
    end

    def self.policies
      @policies ||= {}
    end

    def self.rack_servers
      @rack_servers ||= {}
    end

    def self.transports
      @transports ||= {}
    end

    def self.transport_stores
      @transport_stores ||= {}
    end

    # installer options and config

    def self.module_directories
      %w[databases transports transport_stores]
    end

    # installer paths

    def self.base_path
      @base_path ||= File.realpath(File.join(File.dirname(File.realpath(__FILE__)), 'installer'))
    end

    def self.templates_path
      @templates_path ||= File.realpath(File.join(File.dirname(File.realpath(__FILE__)), 'installer', 'templates'))
    end

    # app paths

    def self.asset_output_path
      File.join('public', 'assets')
    end

    def self.entrypoint_path(entrypoint)
      File.join(isomorfeus_path, 'imports', entrypoint)
    end

    def self.isomorfeus_path
      'isomorfeus'
    end

    def self.stylesheet_path(stylesheet)
      File.join(isomorfeus_path, 'styles', stylesheet)
    end

    def self.middlewares_includes
      'extend Isomorfeus::Transport::Middlewares'
    end

    # install helpers

    def self.generate_gem_line(gem_hash)
      line = "gem '#{gem_hash[:name]}', '#{gem_hash[:version]}'"
      line << ", require: false" if gem_hash.has_key?(:require) && !gem_hash[:require]
      line << "\n"
    end

    def self.create_directories
      create_directory(File.join(isomorfeus_path, 'imports'))
      create_directory(File.join(isomorfeus_path, 'components'))
      create_directory(File.join(isomorfeus_path, 'models'))
      create_directory(File.join(isomorfeus_path, 'operations'))
      create_directory(File.join(isomorfeus_path, 'policies'))
      create_directory(File.join(isomorfeus_path, 'styles'))
      create_directory('spec')
    end

    def self.create_directory(directory)
      unless Dir.exist?(directory)
        puts "Creating directory #{directory}."
        FileUtils.mkdir_p(directory)
        FileUtils.touch(File.join(directory, '.keep'))
      end
    end

    def self.create_file_from_template(template_path, target_file_path, data_hash)
      template = ERB.new(File.read(File.join(templates_path, template_path), mode: 'r'))
      result = template.result_with_hash(data_hash)
      ext = File.exist?(target_file_path) ? '_new' : ''
      File.write(target_file_path + ext, result, mode: 'w')
    end

    def self.install_framework
      data_hash = { app_class:                      app_class,
                    isomorfeus_config:              create_isomorfeus_config,
                    middlewares:                    create_middlewares,
                    middlewares_includes:           middlewares_includes,
                    transport_rack_app_mount_path:  transport&.rack_app_mount_path,
                    transport_rack_app:             transport&.rack_app,
                    transport_config:               transport&.config,
                    use_transport:                  use_transport?,
                    use_transport_rack_app:         use_transport_rack_app? }
      create_file_from_template('app.rb.erb', "#{@project_name}_app.rb", data_hash)
      data_hash = { app_require: app_require, app_class: app_class }
      create_file_from_template('config_ru.erb', 'config.ru', data_hash)
      data_hash = { project_env: @project_env }
      create_file_from_template(File.join('app_loader.rb.erb'), 'app_loader.rb', data_hash)
    end

    def self.install_isomorfeus_entries
      data_hash = { app_class:          app_class,
                    use_database:       use_database?,
                    use_i18n:           use_i18n?,
                    use_operation:      use_operation?,
                    use_policy:         use_policy?,
                    use_transport:      use_transport?,
                    transport_requires: use_transport? ? transport.requires : nil }

      create_file_from_template('isomorfeus_loader.rb.erb', File.join(isomorfeus_path, 'isomorfeus_loader.rb'), data_hash)
      create_file_from_template('isomorfeus_web_worker_loader.rb.erb', File.join(isomorfeus_path, 'isomorfeus_web_worker_loader.rb'), data_hash)
    end

    def self.install_js_entries

      data_hash = { use_transport:    use_transport_import?,
                    transport_import: (use_transport_import? ? transport.js_import : nil),
                    transport_global: (use_transport_import? ? transport.js_global : nil) }
      create_file_from_template('application.js.erb', entrypoint_path('application.js'), data_hash)
      create_file_from_template('application_common.js.erb', entrypoint_path('application_common.js'), data_hash)
      create_file_from_template('application_debug.js.erb', entrypoint_path('application_debug.js'), data_hash)
      create_file_from_template('application_ssr.js.erb', entrypoint_path('application_ssr.js'), data_hash)
      create_file_from_template('application_web_worker.js.erb', entrypoint_path('application_web_worker.js'), data_hash)
    end

    def self.install_styles
      create_file_from_template('application.css.erb', stylesheet_path('application.css'), {})
    end

    def self.create_gemfile
      rack_server_gems = ''
      Isomorfeus::Installer.rack_servers[options[:rack_server]]&.fetch(:gems)&.each do |gem|
        rack_server_gems << generate_gem_line(gem)
      end
      transport_gems = ''
      Isomorfeus::Installer.transports[options[:transport]]&.fetch(:gems)&.each do |gem|
        transport_gems << generate_gem_line(gem)
      end
      Isomorfeus::Installer.transport_stores[options[:transport_store]]&.fetch(:gems)&.each do |gem|
        transport_gems << generate_gem_line(gem)
      end
      database_gems = ''
      Isomorfeus::Installer.databases[options[:database]]&.fetch(:gems)&.each do |gem|
        database_gems << generate_gem_line(gem)
      end
      i18n_gems = ''
      Isomorfeus::Installer.i18ns['i18n']&.fetch(:gems)&.each do |gem|
        i18n_gems << generate_gem_line(gem)
      end
      operation_gems = ''
      Isomorfeus::Installer.operations['operation']&.fetch(:gems)&.each do |gem|
        operation_gems << generate_gem_line(gem)
      end
      policy_gems = ''
      Isomorfeus::Installer.policies['policy']&.fetch(:gems)&.each do |gem|
        policy_gems << generate_gem_line(gem)
      end

      data_hash = { database_gems:      database_gems.chop,
                    i18n_gems:          i18n_gems.chop,
                    operation_gems:     operation_gems.chop,
                    policy_gems:        policy_gems.chop,
                    rack_server_gems:   rack_server_gems.chop,
                    transport_gems:     transport_gems.chop }
      create_file_from_template('Gemfile.erb', 'Gemfile', data_hash)
    end

    def self.create_component
      data_hash = { component_name: component_name }
      create_file_from_template('my_component.rb.erb',
                                File.join(isomorfeus_path, 'components', component_name.underscore + '.rb'), data_hash)
    end

    def self.create_middlewares
      "use_isomorfeus_middlewares" if options.has_key?(:transport)
    end

    def self.create_isomorfeus_config
      '' # "Isomorfeus.env = ENV['#{project_env}']"
    end

    def self.create_package_json
      npms = ''
      if use_transport? && transports[options[:transport]].has_key?(:npms)
        transports[options[:transport]][:npms].each do |npm|
          npms << "    \"#{npm[:name]}\": \"#{npm[:version]}\",\n"
        end
      end
      data_hash = { application_name: app_class,
                    npm_packages:     npms.chop }
      create_file_from_template('package.json.erb', 'package.json', data_hash)
    end

    def self.create_procfile
      data_hash = { rack_server_start_command: rack_server[:start_command] }
      create_file_from_template('Procfile.erb', 'Procfile', data_hash)
      create_file_from_template('ProcfileDebug.erb', 'ProcfileDebug', data_hash)
    end

    def self.create_spec
      data_hash = { app_class: app_class, app_require: app_require, project_env: project_env, rack_server: rack_server_name }
      create_file_from_template('spec_helper.rb.erb', File.join('spec', 'spec_helper.rb'), data_hash)
      create_file_from_template('test_spec.rb.erb', File.join('spec', 'test_spec.rb'), {})
    end

    def self.create_toplevel
      data_hash = { app_class: app_class, component_name: component_name }
      create_file_from_template('my_app.rb.erb',
                                File.join(isomorfeus_path, 'components', app_class.underscore + '.rb'), data_hash)
    end

    def self.use_asset_bundler?
      options.has_key?('asset_bundler')
    end

    def self.use_database?
      options.has_key?('database')
    end

    def self.use_i18n?
      options['i18n']
    end

    def self.use_operation?
      options['operation']
    end

    def self.use_policy?
      options['policy']
    end

    def self.use_transport?
      options.has_key?('transport')
    end

    def self.use_transport_import?
      use_transport? && transport&.respond_to?(:js_import)
    end

    def self.use_transport_rack_app?
      transport&.respond_to?(:rack_app)
    end
  end
end