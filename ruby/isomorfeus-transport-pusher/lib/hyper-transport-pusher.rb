require 'isomorfeus-transport'

if RUBY_ENGINE == 'opal'
  require 'isomorfeus/transport/pusher/client_driver'
else
  require 'isomorfeus/transport/pusher/server_driver'
  require 'isomorfeus/transport/pusher/config'
  Opal.append_path(__dir__.untaint) unless Opal.paths.include?(__dir__.untaint)
end