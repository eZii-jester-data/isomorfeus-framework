require 'isomorfeus-transport'

if RUBY_ENGINE == 'opal'
  #require 'isomorfeus/transport/action_cable/subscription'
  #require 'isomorfeus/transport/action_cable/subscriptions'
  #require 'isomorfeus/transport/action_cable/consumer'
  require 'isomorfeus/transport/action_cable/client_driver'
else
  require 'action_cable'
  require 'isomorfeus/transport/action_cable/server_driver'
  require 'isomorfeus/transport/action_cable/config'
  Opal.append_path(__dir__.untaint) unless Opal.paths.include?(__dir__.untaint)
end