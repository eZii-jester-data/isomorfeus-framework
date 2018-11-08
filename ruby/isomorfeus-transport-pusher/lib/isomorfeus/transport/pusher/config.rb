module Isomorfeus
  if RUBY_ENGINE = 'opal'
    add_client_option(:pusher_options, {})
    add_client_init_class_name('Isomorfeus::Transport::Pusher::ClientDriver')
  else
    # available settings
    class << self
      attr_accessor :pusher_server_options
    end
    # default values
    self.pusher_server_options = {}
    self.server_pub_sub_driver = Isomorfeus::Transport::Pusher::ServerDriver
  end
end