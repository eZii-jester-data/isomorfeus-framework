module Isomorfeus
  module Transport
    module ActionCable
      class ClientDriver
        def self.init
          @consumer_instance = `ActionCable.createConsumer.apply(ActionCable, [#{Isomorfeus.action_cable_consumer_url}])`
          notification_channel = "#{Isomorfeus.transport_notification_channel_prefix}#{Isomorfeus.session_id}"
          %x{
          #{@consumer_instance}.subscriptions.create({ channel: 'Isomorfeus::Transport::ActionCable::IsomorfeusChannel', session_id: #{notification_channel} }, {
              received: function(data) {
                return #{Isomorfeus::Transport.process_response_or_notification(`data`)};
              }
            })
          }
        end

        def self.consumer_instance
          @consumer_instance
        end
      end
    end
  end
end