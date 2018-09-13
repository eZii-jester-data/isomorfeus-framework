# isomorfeus-transport-pusher
Driver for Pusher.com pub sub service for isomorfeus-transport for isomorfeus.

# Installation
get from repo

# Config

in your frameworks config or initializer:

```ruby
    Isomorfeus.pusher_options = {} # options for the Pusher client on the client to use
    Isomorfeus.pusher_server_options = {} # options for the pusher client on the server to use
    
    # that gets set automatically if you include this gem:
    Isomorfeus.server_pub_sub_driver = Isomorfeus::Transport::Pusher::ServerDriver
```