module Redux
  def self.create_store(reducer, preloaded_state = nil, enhancer = nil)
    Redux::Store.new(reducer, preloaded_state, enhancer)
  end

  def self.combine_reducers(*reducers)
    `Redux.combineReducers(reducers)`
  end

  def self.apply_middleware(*middlewares)
    `Redux.applyMiddleware(middlewares)`
  end

  def self.bind_action_creators(*args)
    dispatch = args.pop()
    `Redux.bindActionCreators(args, dispatch)`
  end

  def self.compose(*functions)
    `Redux.compose(functions)`
  end

  def self.create_reducer(&block)
    %x{
      return (function(previous_state, action) {
        var new_state = block.$call(Opal.Hash.$new(previous_state), Opal.Hash.$new(action));
        if (typeof new_state.$class === "function") { new_state = new_state.$to_n(); }
        return result;
      });
    }
  end
end