require 'opal-activesupport'

if RUBY_ENGINE == 'opal'
  require 'vis'
  require 'isomorfeus-react'
  require 'lucid_vis/graph2d/mixin'
  require 'lucid_vis/graph2d/base'
  require 'lucid_vis/graph3d/mixin'
  require 'lucid_vis/graph3d/base'
  require 'lucid_vis/network/mixin'
  require 'lucid_vis/network/base'
  require 'lucid_vis/timeline/mixin'
  require 'lucid_vis/timeline/base'
else
  require 'vis/railtie' if defined?(Rails)
  Opal.append_path __dir__.untaint
end