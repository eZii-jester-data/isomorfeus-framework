module Isomorfeus
  module Installer
    # driver support

    def self.add_database(name, props)
      databases[name] = props
    end

    def self.add_policy_module(name, props)
      policies[name] = props
    end

    def self.add_rack_server(name, props)
      rack_servers[name] = props
    end

    class << self
      # application options
      attr_reader   :app_class
      attr_reader   :app_require
      attr_accessor :database
      attr_accessor :framework
      attr_accessor :policy
      attr_reader   :project_dir
      attr_reader   :project_name
      attr_accessor :rack_server
      attr_accessor :rack_server_name

      # installer options
      attr_reader :options
    end

    def self.set_project_names(pro_dir)
      @project_dir    = pro_dir
      @project_name   = pro_dir.underscore
      @app_class      = @project_name.camelize + 'App'
      @app_require    = @project_name + '_app'
    end

    def self.options=(options)
      Isomorfeus::Installer::OptionsMangler.mangle_options(options)
      @options = options
    end

    def self.sorted_databases
      databases.keys.sort
    end

    def self.sorted_policies
      policies.keys.sort
    end

    def self.sorted_rack_servers
      rack_servers.keys.sort
    end

    def self.databases
      @databases ||= {}
    end

    def self.policies
      @policies ||= {}
    end

    def self.rack_servers
      @rack_servers ||= {}
    end

    # installer options and config

    def self.module_directories
      %w[databases]
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
      create_directory(File.join(isomorfeus_path, 'channels'))
      create_directory(File.join(isomorfeus_path, 'components'))
      create_directory(File.join(isomorfeus_path, 'data'))
      create_directory(File.join(isomorfeus_path, 'handlers'))
      create_directory(File.join(isomorfeus_path, 'locales'))
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
                    rack_server_init:               rack_server[:rack_server_init] }
      create_file_from_template('app.rb.erb', "#{@project_name}_app.rb", data_hash)
      create_file_from_template( rack_server[:init_template], rack_server[:init_template][0..-5], {})
      data_hash = { app_require: app_require, app_class: app_class }
      create_file_from_template('config.ru.erb', 'config.ru', data_hash)
      create_file_from_template(File.join('app_loader.rb.erb'), 'app_loader.rb', {})
    end

    def self.install_isomorfeus_entries
      data_hash = { app_class:          app_class,
                    use_policy:         use_policy? }
      create_file_from_template('isomorfeus_loader.rb.erb', File.join(isomorfeus_path, 'isomorfeus_loader.rb'), data_hash)
      create_file_from_template('isomorfeus_web_worker_loader.rb.erb', File.join(isomorfeus_path, 'isomorfeus_web_worker_loader.rb'), data_hash)
    end

    def self.install_js_entries
      data_hash = {}
      create_file_from_template('application.js.erb', entrypoint_path('application.js'), data_hash)
      create_file_from_template('application_common.js.erb', entrypoint_path('application_common.js'), data_hash)
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
      database_gems = ''
      Isomorfeus::Installer.databases[options[:database]]&.fetch(:gems)&.each do |gem|
        database_gems << generate_gem_line(gem)
      end
      policy_gems = ''
      Isomorfeus::Installer.policies['policy']&.fetch(:gems)&.each do |gem|
        policy_gems << generate_gem_line(gem)
      end

      data_hash = { database_gems:      database_gems.chop,
                    policy_gems:        policy_gems.chop,
                    rack_server_gems:   rack_server_gems.chop,
                    isomorfeus_version: Isomorfeus::Installer::VERSION
      }
      create_file_from_template('Gemfile.erb', 'Gemfile', data_hash)
    end

    def self.create_components
      data_hash = { app_class: app_class }
      create_file_from_template('my_app.rb.erb',
                                File.join(isomorfeus_path, 'components', app_class.underscore + '.rb'), data_hash)
      create_file_from_template('hello_component.rb.erb',
                                File.join(isomorfeus_path, 'components', 'hello_component.rb'), {})
      create_file_from_template('navigation_links.rb.erb',
                                File.join(isomorfeus_path, 'components', 'navigation_links.rb'), {})
      create_file_from_template('welcome_component.rb.erb',
                                File.join(isomorfeus_path, 'components', 'welcome_component.rb'), {})
    end

    def self.create_middlewares
      "use_isomorfeus_middlewares"
    end

    def self.create_isomorfeus_config
      '' # "Isomorfeus.env = ENV['#{project_env}']"
    end

    def self.create_package_json
      data_hash = { application_name: app_class }
      create_file_from_template('package.json.erb', 'package.json', data_hash)
    end

    def self.create_procfile
      data_hash = { rack_server_start_command: rack_server[:start_command] }
      create_file_from_template('Procfile.erb', 'Procfile', data_hash)
      create_file_from_template('ProcfileDebug.erb', 'ProcfileDebug', data_hash)
    end

    def self.create_spec
      data_hash = { app_class: app_class, app_require: app_require, rack_server: rack_server_name }
      create_file_from_template('spec_helper.rb.erb', File.join('spec', 'spec_helper.rb'), data_hash)
      create_file_from_template('test_spec.rb.erb', File.join('spec', 'test_spec.rb'), {})
    end

    def self.use_asset_bundler?
      options.has_key?('asset_bundler')
    end

    def self.use_policy?
      options['policy']
    end
  end
end