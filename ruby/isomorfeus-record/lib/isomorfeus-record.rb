require 'opal-activesupport'
require 'isomorfeus-store'
require 'isomorfeus-component'
require 'isomorfeus-transport'

if RUBY_ENGINE == 'opal'
  require 'isomorfeus-transport-http' # TODO, this is actually optional, might be a different transport
  require 'isomorfeus/model/helpers'
  require 'isomorfeus/model/driver/generic'
  require 'isomorfeus/model/driver/active_record'
  require 'isomorfeus/model/driver/neo4j'
  require 'isomorfeus/record/dummy_value'
  require 'isomorfeus/record/collection'
  require 'isomorfeus/record/client_class_methods'
  require 'isomorfeus/record/client_class_processor'
  require 'isomorfeus/record/client_instance_methods'
  require 'isomorfeus/record/client_instance_processor'
  require 'ismo_record/mixin'
  require 'ismo_record/base'
else
  require 'active_support'
  require 'oj'
  require 'isomorfeus/promise'
  require 'isomorfeus/model/config'
  require 'isomorfeus/model/security_guards' # server side, controller helper methods
  require 'isomorfeus/model/pub_sub'
  require 'isomorfeus/model/driver/generic'
  require 'isomorfeus/model/driver/active_record'
  require 'isomorfeus/model/driver/neo4j'
  require 'isomorfeus/handler/model'
  require 'isomorfeus/handler/model/create_handler'
  require 'isomorfeus/handler/model/destroy_handler'
  require 'isomorfeus/handler/model/link_handler'
  require 'isomorfeus/handler/model/read_handler'
  require 'isomorfeus/handler/model/unlink_handler'
  require 'isomorfeus/handler/model/update_handler'
  require 'isomorfeus/record/server_class_methods'
  require 'isomorfeus/record/server_instance_methods'
  require 'ismo_record/mixin'
  require 'ismo_record/base'
  Opal.append_path(__dir__.untaint)
  if Dir.exist?(File.join('app', 'isomorfeus', 'models'))
    # Opal.append_path(File.expand_path(File.join('app', 'isomorfeus', 'models')))  <- opal-autoloader will handle this
    Opal.append_path(File.expand_path(File.join('app', 'isomorfeus', 'models', 'concerns')))
    Opal.append_path(File.expand_path(File.join('app', 'isomorfeus'))) unless Opal.paths.include?(File.expand_path(File.join('app', 'isomorfeus')))
  elsif Dir.exist?(File.join('isomorfeus', 'models'))
    # Opal.append_path(File.expand_path(File.join('isomorfeus', 'models')))  <- opal-autoloader will handle this
    Opal.append_path(File.expand_path(File.join('isomorfeus', 'models', 'concerns')))
    Opal.append_path(File.expand_path(File.join('isomorfeus'))) unless Opal.paths.include?(File.expand_path(File.join('isomorfeus')))
  end

  # special treatment for rails
  if defined?(Rails)
    module Isomorfeus
      module Model
        class Railtie < Rails::Railtie
          def delete_first(a, e)
            a.delete_at(a.index(e) || a.length)
          end

          config.before_configuration do |_|
            Rails.configuration.tap do |config|
              config.eager_load_paths += %W(#{config.root}/app/isomorfeus/models)
              config.eager_load_paths += %W(#{config.root}/app/isomorfeus/models/concerns)
              # rails will add everything immediately below app to eager and auto load, so we need to remove it
              delete_first config.eager_load_paths, "#{config.root}/app/isomorfeus"

              unless Rails.env.production?
                config.autoload_paths += %W(#{config.root}/app/isomorfeus/models)
                config.autoload_paths += %W(#{config.root}/app/isomorfeus/models/concerns)
                # rails will add everything immediately below app to eager and auto load, so we need to remove it
                delete_first config.autoload_paths, "#{config.root}/app/isomorfeus"
              end
            end
          end
        end
      end
    end
  elsif Dir.exist?(File.join('app', 'isomorfeus'))
    $LOAD_PATH.unshift(File.expand_path(File.join('app', 'isomorfeus', 'models')))
    $LOAD_PATH.unshift(File.expand_path(File.join('app', 'isomorfeus', 'models', 'concerns')))
  elsif Dir.exist?(File.join('isomorfeus'))
    $LOAD_PATH.unshift(File.expand_path(File.join('isomorfeus', 'models')))
    $LOAD_PATH.unshift(File.expand_path(File.join('isomorfeus', 'models', 'concerns')))
  end
end
