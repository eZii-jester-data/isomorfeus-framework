module IsmoComponent
  module Mixin
    def self.included(base)
      base.include(IsmoStore::Mixin)
      base.include(React::Component::API)
      base.include(React::Callbacks)
      base.include(React::Component::Tags)
      base.include(React::Component::DslInstanceMethods)
      base.include(React::Component::ShouldComponentUpdate)
      base.include(Isomorfeus::Params::InstanceMethods)
      base.extend(Isomorfeus::Params::ClassMethods)
      base.include(Isomorfeus::Component::RouterMethods)
      base.extend(React::Component::ClassMethods)
      base.class_eval do
        class_attribute :initial_state
        define_callback :before_mount
        define_callback :after_mount
        define_callback :before_receive_props
        define_callback :before_update
        define_callback :after_update
        define_callback :before_unmount
        define_callback :after_error
      end
    end

    def initialize(native_element)
      @native = native_element
      init_store
    end

    def emit(event_name, *args)
      if React::Event::BUILT_IN_EVENTS.include?(built_in_event_name = "on#{event_name.to_s.event_camelize}")
        params[built_in_event_name].call(*args)
      else
        params["on_#{event_name}"].call(*args)
      end
    end

    def component_will_mount
      React::IsomorphicHelpers.load_context(true) if React::IsomorphicHelpers.on_opal_client?
      React::State.set_state_context_to(self) { run_callback(:before_mount) }
    end

    def component_did_mount
      React::State.set_state_context_to(self) do
        run_callback(:after_mount)
        React::State.update_states_to_observe
      end
    end

    def component_will_receive_props(next_props)
      # need to rethink how this works in opal-react, or if its actually that useful within the react.rb environment
      # for now we are just using it to clear processed_params
      React::State.set_state_context_to(self) { self.run_callback(:before_receive_props, next_props) }
    end

    def component_will_update(next_props, next_state)
      React::State.set_state_context_to(self) { self.run_callback(:before_update, next_props, next_state) }
    end

    def component_did_update(prev_props, prev_state)
      React::State.set_state_context_to(self) do
        self.run_callback(:after_update, prev_props, prev_state)
        React::State.update_states_to_observe
      end
    end

    def component_will_unmount
      React::State.set_state_context_to(self) do
        self.run_callback(:before_unmount)
        React::State.remove
      end
    end

    def component_did_catch(error, info)
      React::State.set_state_context_to(self) do
        if self.class.callbacks_for(:after_error) == []
          if `typeof error.$backtrace === "function"`
            `console.error(error.$backtrace().$join("\n"))`
          else
            `console.error(error, info)`
          end
        else
          self.run_callback(:after_error, error, info)
        end
      end
    end

    attr_reader :waiting_on_resources

    def update_react_js_state(object, name, value)
      if object
        name = "#{object.class}.#{name}" unless object == self
        # Date.now() has only millisecond precision, if several notifications of
        # observer happen within a millisecond, updates may get lost.
        # to mitigate this the Math.random() appends some random number
        # this way notifications will happen as expected by the rest of isomorfeus
        set_state(
          '***_state_updated_at-***' => `Date.now() + Math.random()`,
          name => value
        )
      else
        set_state name => value
      end
    end

    def set_state_synchronously?
      @native.JS[:__opalInstanceSyncSetState]
    end

    def render
      raise 'no render defined'
    end unless method_defined?(:render)

    def _render_wrapper
      React::State.set_state_context_to(self, true) do
        element = React::RenderingContext.render(nil) { render || '' }
        @waiting_on_resources =
          element.waiting_on_resources if element.respond_to? :waiting_on_resources
        element
      end
    end

    def watch(value, &on_change)
      Observable.new(value, on_change)
    end

    def define_state(*args, &block)
      React::State.initialize_states(self, self.class.define_state(*args, &block))
    end
  end
end
