module React
  module Component
    class State
      include ::Native::Wrapper

      alias _original_method_missing method_missing

      def method_missing(key, *args, &block)
        if key.end_with?('=')
          new_state = `{}`
          new_state.JS[key.chop] = args[0]
          if block_given?
            @native.JS.setState(new_state, `function() { block.$call(); }`)
          else
            @native.JS.setState(new_state, `null`)
          end
        else
          return nil if `typeof #@native.state[key] == "undefined"`
          @native.JS[:state].JS[key]
        end
      end

      def set_state(updater, &block)
        new_state = `{}`
        updater.keys.each do |key|
          new_state.JS[key] = updater[key]
        end
        if block_given?
          @native.JS.setState(new_state, `function() { block.$call(); }`)
        else
          @native.JS.setState(new_state, `null`)
        end
      end

      def to_n
        @native.JS[:state]
      end
    end
  end
end