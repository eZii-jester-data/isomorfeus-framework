module Isomorfeus
  module Transport
    module Pusher
      class ClientDriver
        def self.init
          if Isomorfeus.pusher_options[:client_logging] && `console && console.log`
            `Pusher.log = function(message) {console.log(message);}`
          end

          pusher_api = nil

          %x{
            var pusher_config = {
              encrypted: #{Isomorfeus.pusher_options[:encrypted]},
              cluster: #{Isomorfeus.pusher_options[:cluster]}

            };
            pusher_api = new Pusher(#{Isomorfeus.pusher_options[:key]}, pusher_config)
          }
          Isomorfeus.pusher_options[:pusher_api] = pusher_api

          if Isomorfeus.options.has_key?(:session_id)
            notification_channel = "#{Isomorfeus.transport_notification_channel_prefix}#{Isomorfeus.session_id}"
            Isomorfeus.pusher_options[:channel] = pusher_api.JS.subscribe(notification_channel)
            Isomorfeus.pusher_options[:channel].JS.bind('update', `function(data){
              return #{Isomorfeus::Transport.process_response_or_notification(`data`)};
            }`)
          end

          @pusher_instance = pusher_api
        end

        def self.pusher_instance
          @pusher_instance
        end
      end
    end
  end
end