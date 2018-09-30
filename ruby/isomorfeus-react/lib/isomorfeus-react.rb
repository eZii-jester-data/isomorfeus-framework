if RUBY_ENGINE == 'opal'
  require 'native'
  require 'active_support/core_ext/string'
  require 'browser/support'
  require 'browser/event'
  require 'browser/event_source'
  require 'browser/screen'
  require 'browser/socket'
  require 'browser/window'
  require 'browser/dom/node'
  require 'browser/dom/element'
  require 'react/version'
  require 'react/props_converters'
  require 'react'
  # require 'react/element' # usually not needed
  require 'react/synthetic_event'
  require 'react_dom'
  # React.Component
  require 'react/component/api'
  require 'react/native_constant_wrapper'
  require 'react/component/native_component'
  require 'react/component/props'
  require 'react/component/state'
  require 'react/component/elements'
  require 'react/component/resolution'
  require 'react/component/should_component_update'
  require 'react/component/event_handler'
  require 'react/component/mixin'
  require 'react/component/base'
  # React.PureComponent
  require 'react/pure_component/native_component'
  require 'react/pure_component/mixin'
  require 'react/pure_component/base'
  # Functional Component
  require 'react/functional_component/creator'
  require 'react/functional_component/runner'
else
  require 'opal'
  require 'opal-activesupport'
  require 'opal-browser'

  require 'isomorfeus/config'

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