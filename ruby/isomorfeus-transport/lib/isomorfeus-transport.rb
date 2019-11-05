require 'isomorfeus-policy'
require 'lucid_authentication/mixin'
if RUBY_ENGINE == 'opal'
  require 'json'
  require 'isomorfeus/config'
  require 'isomorfeus/execution_environment'
  require 'isomorfeus/transport/version'
  require 'isomorfeus/transport/config'
  require 'isomorfeus/transport/request_agent'
  require 'isomorfeus/transport/client_processor'
  require 'isomorfeus/transport/websocket'
  require 'isomorfeus/transport'
  require 'lucid_channel/mixin'
  require 'lucid_channel/base'
  Isomorfeus.zeitwerk.push_dir('channels')
  Isomorfeus.add_client_init_class_name('Isomorfeus::Transport')
else
  require 'base64'
  require 'digest'
  require 'ostruct'
  require 'socket'
  require 'oj'
  require 'websocket/driver'
  require 'active_support'
  require 'iodine'
  require 'isomorfeus/config'
  require 'isomorfeus/promise'
  require 'isomorfeus/transport/version'
  require 'isomorfeus/transport/response_agent'
  require 'isomorfeus/transport/config'
  require 'isomorfeus/transport/middlewares'
  require 'isomorfeus/transport/request_agent'
  require 'isomorfeus/transport/server_processor'
  require 'isomorfeus/transport/server_socket_processor'
  require 'isomorfeus/transport/websocket'

  require 'isomorfeus/transport/rack_middleware'
  require 'isomorfeus/transport/middlewares'

  Isomorfeus.add_middleware(Isomorfeus::Transport::RackMiddleware)

  require 'lucid_handler/mixin'
  require 'lucid_handler/base'
  require 'lucid_channel/mixin'
  require 'lucid_channel/base'

  require 'isomorfeus/transport/handler/authentication_handler'

  Opal.append_path(__dir__.untaint) unless Opal.paths.include?(__dir__.untaint)

  %w[channels handlers].each do |dir|
    path = Dir.exist?(File.join('isomorfeus')) ? File.expand_path(File.join('isomorfeus', dir)) : nil
    if path && Dir.exist?(path)
      Isomorfeus.zeitwerk.push_dir(path)
    end
  end
end
