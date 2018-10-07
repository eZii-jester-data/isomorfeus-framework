module Redux
  class Store
    include Native::Wrapper

    def initialize(reducer, preloaded_state = `null`, enhancer = `null`)
      %x{
        if (typeof action.$class === "function" && action.$class() === "Hash") {
          this.native = Redux.createStore(reducer, preloaded_state.$to_n(), enhancer);
        } else {
          this.native = Redux.createStore(reducer, preloaded_state, enhancer);
        }
      }
    end

    def dispatch(action)
      %x{
        if (typeof action.$class === "function" && action.$class() === "Hash") {
          this.native.dispatch(action.$to_n());
        } else {
          this.native.dispatch(action);
        }
      }
    end

    def get_state
      Hash.new(`this.native.getState()`)
    end

    def replace_reducer(next_reducer)
      `this.native.replaceReducer(next_reducer)`
    end

    # returns function needed to unsubscribe the listener
    def subscribe(&listener)
      `this.native.subscribe(function() { return listener$.call(); })`
    end
  end
end