module Isomorfeus
  module Transport
    module ServerPubSub
      def self.publish(object_string, message)
        session_ids = Isomorfeus.server_subscription_store.get_and_touch_subscribers(object_string)
        if session_ids.any?
          notification_channels = session_ids.map { |session_id| "#{Isomorfeus.transport_notification_channel_prefix}#{session_id}" }
          Isomorfeus.server_pub_sub_driver.publish(notification_channels, message)
        end
      end

      def self.publish_to_session(session_id, message)
        Isomorfeus.server_pub_sub_driver.publish("#{Isomorfeus.transport_notification_channel_prefix}#{session_id}", message)
      end

      def self.subscribe(object_string, session_id)
        Isomorfeus.server_subscription_store.save_subscription(object_string, session_id)
      end

      def self.subscribe_to_many(object_strings, session_id)
        Isomorfeus.server_subscription_store.save_subscriptions(object_strings, session_id)
      end

      def self.unsubscribe(object_string, session_id)
        Isomorfeus.server_subscription_store.delete_subscription(object_string, session_id)
      end

      def self.unsubscribe_all(object_string)
        Isomorfeus.server_subscription_store.delete_all_subscriptions(object_string)
      end

      def self.pub_sub(object_string, session_id, message)
        subscribe(object_string, session_id)
        publish(object_string, message)
      end
    end
  end
end
