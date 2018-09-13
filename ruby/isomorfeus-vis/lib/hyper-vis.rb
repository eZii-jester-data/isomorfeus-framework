require 'opal-activesupport'

if RUBY_ENGINE == 'opal'
  require 'vis'
  require 'isomorfeus-component'
  require 'isomorfeus/vis/graph2d/mixin'
  require 'isomorfeus/vis/graph2d/component'
  require 'isomorfeus/vis/graph3d/mixin'
  require 'isomorfeus/vis/graph3d/component'
  require 'isomorfeus/vis/network/mixin'
  require 'isomorfeus/vis/network/component'
  require 'isomorfeus/vis/timeline/mixin'
  require 'isomorfeus/vis/timeline/component'
else
  require 'vis/railtie' if defined?(Rails)
  Opal.append_path __dir__.untaint
end