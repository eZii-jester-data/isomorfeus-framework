module Redux
  class Store
    include Native::Wrapper
    def self.add_reducer(reducer)
      if Isomorfeus.store
        # if the store has been initalized already, add the reducer to the instance
        Isomorfeus.store.add_reducer(reducer)
      else
        # otherwise just add it to the reducers, so that they will be used when initializing the store
        reducers.merge!(reducer)
      end
    end

    def self.add_reducers(new_reducers)
      if Isomorfeus.store
        # if the store has been initalized already, add the reducer to the instance
        Isomorfeus.store.add_reducers(new_reducers)
      else
        # otherwise just add it to the reducers, so that they will be used when initializing the store
        reducers.merge!(new_reducers)
      end
    end

    # called from Isomorfeus.init
    def self.init!
      next_reducer = Redux.combine_reducers(@reducers)
      Redux::Store.new(next_reducer, preloaded_state)
    end

    def self.preloaded_state_merge!(ruby_hash)
      preloaded_state.merge!(ruby_hash)
    end

    def self.preloaded_state
      @preloaded_state ||= {}
    end

    def self.preloaded_state=(ruby_hash)
      @preloaded_state = ruby_hash
    end

    def self.reducers
      @reducers ||= {}
    end

    def initialize(reducer, preloaded_state = `null`, enhancer = `null`)
      %x{
        var real_preloaded_state;
        if (typeof preloaded_state.$class === "function" && preloaded_state.$class() == "Hash") {
          if (preloaded_state.$size() == 0) {
            real_preloaded_state = null;
          } else {
            real_preloaded_state = preloaded_state.$to_n();
          }
        } else if (preloaded_state == nil) {
          real_preloaded_state = null;
        } else {
          real_preloaded_state = preloaded_state;
        }
        if (enhancer && real_preloaded_state) {
          this.native = Redux.createStore(reducer, real_preloaded_state, enhancer);
        } else if (real_preloaded_state) {
          this.native = Redux.createStore(reducer, real_preloaded_state);
        } else if (enhancer) {
          this.native = Redux.createStore(reducer, null, enhancer);
        } else {
          this.native = Redux.createStore(reducer);
        }
      }
    end

    def add_reducer(reducer)
      self.class.reducers << reducer
      next_reducer = Redux.combine_reducers(*self.class.reducers)
      self.replace_reducer = next_reducer
    end

    def add_reducers(new_reducers)

      self.class.reducers.merge!(new_reducers)

      next_reducer = Redux.combine_reducers(self.class.reducers)
      replace_reducer(next_reducer)
    end

    def dispatch(action)
      %x{
        if (typeof action.$class === "function" && action.$class() == "Hash") {
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