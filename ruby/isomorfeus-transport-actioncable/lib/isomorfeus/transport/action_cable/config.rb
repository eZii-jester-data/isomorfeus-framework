module Isomorfeus
  if RUBY_ENGINE == 'opal'
    self.add_client_options(:action_cable_consumer_url)
    self.add_client_init_class_name('Isomorfeus::Transport::ActionCable::ClientDriver')
  else
    # default values
    # TODO: How to pass to client?
    # self.action_cable_consumer_url = ActionCable::INTERNAL[:default_mount_path]

    self.server_pub_sub_driver = Isomorfeus::Transport::ActionCable::ServerDriver
  end
end