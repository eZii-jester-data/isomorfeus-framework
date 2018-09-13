# isomorfeus-transport-store-redis
A subscription store for isomorfeus-transport

## Installation

get from repo

## Configuration

in your frameworks config or initializer: 

```ruby
  # thats set by default
  Isomorfeus.server_subscription_store = Isomorfeus::Transport::SubscriptionStore::Redis
  
  # that can be adjusted to the options Redis would usually accept
  Isomorfeus.redis_options = {}
```
