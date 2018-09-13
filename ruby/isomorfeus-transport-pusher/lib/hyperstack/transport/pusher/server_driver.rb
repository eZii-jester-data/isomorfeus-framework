require 'pusher'

module Isomorfeus
  module Transport
    module Pusher
      class ServerDriver
        def self.pusher_instance
          @pusher_instance ||= ::Pusher::Client.new(Isomorfeus.pusher_server_options)
        end

        def self.publish(channels, message)
          pusher_instance.trigger_async(channels, 'update', message)
        end
      end
    end
  end
end
