module Isomorfeus
  module Installer

    # driver support

    def self.add_asset_bundler(name, props)
      asset_bundlers[name] = props
    end

    def self.add_database(name, props)
      databases[name] = props
    end

    def self.add_framework(name, props)
      frameworks[name] = props
    end

    def self.add_transport(name, props)
      transports[name] = props
    end

    def self.asset_bundler
      @asset_bundler
    end

    def self.asset_bundler=(asset_b)
      @asset_bundler = asset_b
    end

    def self.asset_bundlers
      @asset_bundlers ||= {}
    end

    def self.databases
      @databases ||= {}
    end

    def self.frameworks
      @frameworks ||= {}
    end

    def self.framework
      @framework
    end

    def self.framework=(frame_w)
      @framework = frame_w
    end

    def self.transports
      @transports ||= {}
    end

    def self.structure=(struct)
      @structure = struct
    end

    def self.structure
      @structure
    end

    # installer options and config

    def self.options
      @options
    end

    def self.options=(opts)
      @options = opts
    end

    def self.module_directories
      %w[asset_bundlers databases frameworks transports]
    end

    # installer paths
    #
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

    def self.entrypoint
      'application.js'
    end

    def self.entrypoint_path
      if structure == :app_iso
        File.join('app', 'assets', 'javascripts', entrypoint)
      else
        File.join('assets', 'javascripts', entrypoint)
      end
    end

    def self.isomorfeus_path
      if structure == :app_iso
        File.join('app', 'isomorfeus')
      else
        'isomorfeus'
      end
    end

    def self.stylesheets_path
      if structure == :app_iso
        File.join('app', 'assets', 'stylesheets')
      else
        File.join('assets', 'stylesheets')
      end
    end

    # install helpers

    def self.create_directories
      if structure == :app_iso
        Dir.mkdir('config') unless Dir.exist?('config')
        Dir.mkdir('app') unless Dir.exist?('app')
        Dir.chdir('app')
      end
      Dir.mkdir('isomorfeus') unless Dir.exist?('isomorfeus')
      Dir.chdir('isomorfeus')
      Dir.mkdir('components') unless Dir.exist?('components')
      if use_database?
        Dir.mkdir('models') unless Dir.exist?('models')
      end

      Dir.chdir('..') if structure == :app_iso
      Dir.chdir('..')

      Dir.mkdir('public') unless Dir.exist?('public')
      Dir.mkdir('public/assets') unless Dir.exist?('public/assets')
      Dir.mkdir('assets') unless Dir.exist?('assets')
      Dir.mkdir('assets/javascripts') unless Dir.exist?('assets/javascripts')
      Dir.mkdir('assets/stylesheets') unless Dir.exist?('assets/stylesheets')
    end

    def self.create_file_from_template(template_path, target_file_path, data_hash)
      template = ERB.new(File.read(File.join(templates_path, template_path), mode: 'r'))
      result = template.result_with_hash(data_hash)
      ext = File.exist?(target_file_path) ? '_new' : ''
      File.write(target_file_path + ext, result, mode: 'w')
    end

    def self.create_entrypoint
      data_hash = {}
      create_file_from_template(entrypoint + '.erb', entrypoint_path, data_hash)
    end

    def self.create_gemfile(framework_gems, asset_bundler_gems)
      asset_bundler_gems_result = ''
      asset_bundler_gems.each { |gem| asset_bundler_gems_result << "gem '#{gem[:name]}', '#{gem[:version]}'\n" } if asset_bundler_gems
      if framework_gems == :has_gemfile
        framework_gems_result = File.read('Gemfile')
        File.delete('Gemfile')
        data_hash = { asset_bundler_gems: asset_bundler_gems_result,
                      framework_gems: framework_gems_result,
                      skip_header: true }
      else
        framework_gems_result = ''
        framework_gems.each { |gem| framework_gems_result << "gem '#{gem[:name]}', '#{gem[:version]}'\n" }
        data_hash = { asset_bundler_gems: asset_bundler_gems_result,
                      framework_gems: framework_gems_result }
      end
      create_file_from_template('Gemfile.erb', 'Gemfile', data_hash)
    end

    def self.create_loader(app_name)
      data_hash = { app_name: app_name }
      iso_entry = File.join(isomorfeus_path, 'isomorfeus_loader.rb')
      create_file_from_template('isomorfeus_loader.rb.erb', iso_entry, data_hash)
    end

    def self.create_package_json
      npms = ''
      if options.has_key?(:asset_bundler) && asset_bundlers[options[:asset_bundler]].has_key?(:npms)
        asset_bundlers[options[:asset_bundler]][:npms].each do |npm|
          npms << "\"#{npm[:name]}\": \"#{npm[:version]}\",\n"
        end
      end
      data_hash = { application_name: options[:new],
                    scripts: asset_bundler.respond_to?(:package_scripts) ? asset_bundler.package_scripts : '',
                    npm_packages: npms }
      create_file_from_template('package.json.erb', 'package.json', data_hash)
    end

    def self.create_procfile
      data_hash = { framework_start_command: framework.start_command,
                    asset_bundler_start_command: asset_bundler.start_command }
      create_file_from_template('Procfile.erb', 'Procfile', data_hash)
    end

    def self.create_component(component_name)
      data_hash = { component_name: component_name }
      create_file_from_template('my_component.rb.erb',File.join(isomorfeus_path, 'components', component_name.underscore + '.rb'), data_hash)
    end

    def self.create_toplevel(app_name, component_name)
      data_hash = { app_name: app_name, component_name: component_name }
      create_file_from_template('my_app.rb.erb',File.join(isomorfeus_path, 'components', app_name.underscore + '.rb'), data_hash)
    end

    def self.create_requires
      "require 'bundler/setup'\nBundler.require(:default)\n"
    end

    # def self.require_record?
    #   @require_record
    # end
    #
    # def self.require_operation?
    #   @require_operation
    # end
    #
    # def self.require_policy?
    #   @require_policy
    # end
    #
    # def self.require_spectre?
    #   @require_spectre
    # end

    def self.use_database?
      options.has_key?(:database) && options[:database] != 'none'
    end
  end
end