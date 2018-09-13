if RUBY_ENGINE == 'opal'
  require 'browser/delay'
  require 'isomorfeus-store'
  require 'react'
  require 'react/observable'
  require 'isomorfeus/props_wrapper'
  require 'isomorfeus/validator'

  require 'react/component/dsl_instance_methods'
  require 'react/component/should_component_update'
  require 'react/component/tags'
  require 'react/component/base'
  require 'react/element'
  require 'react/event'
  require 'react/api'
  require 'react/rendering_context'
  require 'react/state'
  require 'react/object'
  require 'react/to_key'
  require 'reactive-ruby/isomorphic_helpers'
  require 'isomorfeus/params/class_methods'
  require 'isomorfeus/params/instance_methods'
  require 'isomorfeus/component/mixin'
  require 'isomorfeus/component'
  require 'isomorfeus/context'
  require 'isomorfeus/top_level'
else
  require 'oj'
  require 'opal'
  require 'isomorfeus-store'
  require 'opal-activesupport'
  require 'opal-browser'
  require 'isomorfeus/component/version'
  require 'reactive-ruby/isomorphic_helpers' # obsolete, but still needed in router
  require 'reactive-ruby/serializers' # same
  require 'isomorfeus/promise'
  require 'isomorfeus/config'
  require 'isomorfeus/view_helpers'
  Opal.append_path(__dir__.untaint)
  if defined?(Rails)
    module Isomorfeus
      module Model
        class Railtie < Rails::Railtie
          def delete_first(a, e)
            a.delete_at(a.index(e) || a.length)
          end

          config.before_configuration do |_|
            Rails.configuration.tap do |config|
              # rails will add everything immediately below app to eager and auto load, so we need to remove it
              delete_first config.eager_load_paths, "#{config.root}/app/isomorfeus"

              unless Rails.env.production?
                # rails will add everything immediately below app to eager and auto load, so we need to remove it
                delete_first config.autoload_paths, "#{config.root}/app/isomorfeus"
              end
            end
          end
        end
      end
    end
  end
  if Dir.exist?(File.join('app', 'isomorfeus'))
    # Opal.append_path(File.expand_path(File.join('app', 'isomorfeus', 'components')))
    Opal.append_path(File.expand_path(File.join('app', 'isomorfeus'))) unless Opal.paths.include?(File.expand_path(File.join('app', 'isomorfeus')))
  elsif Dir.exist?('isomorfeus')
    # Opal.append_path(File.expand_path(File.join('isomorfeus', 'components')))
    Opal.append_path(File.expand_path('isomorfeus')) unless Opal.paths.include?(File.expand_path('isomorfeus'))
  end
end
