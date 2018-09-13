if RUBY_ENGINE != 'opal'
  module Isomorfeus

    # available settings
    class << self
      attr_accessor :action_cable_consumer_url
    end

    self.add_client_options(%i[action_cable_consumer_url])
    self.add_client_init_class_name('Isomorfeus::Transport::ActionCable::ClientDriver')

    # default values
    self.action_cable_consumer_url = ActionCable::INTERNAL[:default_mount_path]

    self.server_pub_sub_driver = Isomorfeus::Transport::ActionCable::ServerDriver
  end
end