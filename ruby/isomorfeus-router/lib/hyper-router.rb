# rubocop:disable Style/FileName

require 'isomorfeus-component'

if RUBY_ENGINE == 'opal'
  require 'react/router'
  require 'react/router/dom'
  require 'react/router/history'

  require 'isomorfeus-router/isomorphic_methods'
  require 'isomorfeus-router/history'
  require 'isomorfeus-router/location'
  require 'isomorfeus-router/match'
  require 'isomorfeus-router/class_methods'
  require 'isomorfeus-router/component_methods'
  require 'isomorfeus-router/instance_methods'

  require 'isomorfeus/router/base'
  require 'isomorfeus/router/browser'
  require 'isomorfeus/router/mixin'
  require 'isomorfeus/router/component'
  require 'isomorfeus/router/hash'
  require 'isomorfeus/router/memory'
  require 'isomorfeus/router/static'
  require 'isomorfeus/router'
else
  require 'opal'
  require 'isomorfeus-router/isomorphic_methods'

  Opal.append_path File.expand_path('../', __FILE__).untaint
end
