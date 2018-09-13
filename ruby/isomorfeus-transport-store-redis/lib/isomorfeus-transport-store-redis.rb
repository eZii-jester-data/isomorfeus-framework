if RUBY_ENGINE == 'opal'
  # nothing
else
  require 'isomorfeus/transport/subscription_store/redis/version'
  require 'isomorfeus/transport/subscription_store/redis/config'
  require 'isomorfeus/transport/subscription_store/redis'
end