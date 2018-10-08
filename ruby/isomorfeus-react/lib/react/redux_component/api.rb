module React
  module ReduxComponent
    module API
      def self.included(base)
        base.instance_exec do
          attr_accessor :class_store
          attr_accessor :store

          def class_store
            @default_class_store ||= ::React::ReduxComponent::StoreDefaults.new(state, self.to_s)
          end

          def component_will_unmount(&block)
            # unsubscriber support for ReduxComponent
            %x{
              if (typeof this.unsubscriber === "function") { this.unsubscriber(); };
              self.react_component.prototype.componentWillUnmount = function() {
                return #{`this.__ruby_instance`.instance_exec(&block)};
              }
            }
          end
        end
      end

      def initialize(native_component)
        @native = native_component
        @class_store = ::React::ReduxComponent::ClassStoreProxy.new(self)
        @props = ::React::Component::Props.new(@native)
        @state = ::React::Component::State.new(@native)
        @store = ::React::ReduxComponent::InstanceStoreProxy.new(self)
      end
    end
  end
end