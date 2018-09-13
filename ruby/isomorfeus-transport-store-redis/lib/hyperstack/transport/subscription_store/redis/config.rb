module Isomorfeus

  # available settings
  class << self
    attr_accessor :server_subscription_store
    attr_accessor :redis_options
  end

  # defaults
  self.server_subscription_store = Isomorfeus::Transport::SubscriptionStore::Redis
  self.redis_options = {}
end
