module React
  extend React::PropsConverters

  %x{
    self.render_buffer = [];
  }

  def self.clone_element(ruby_react_element, props = nil, children = nil, &block)
    block_result = `null`
    if block_given?
      block_result = block.call
      block_result = `null` unless block_result
    end
    native_props = props ? to_native_react_props(props): `null`
    `React.cloneElement(ruby_react_element.$to_n(), native_props, block_result)`
  end

  def self.create_context(const_name, default_value)
    %x{
      Opal.global[const_name] = React.createContext(value);
      var new_const = #{React::NativeConstantWrapper.new(`Opal.global[const_name]`)};
      #{Object.const_set(const_name, `new_const`)};
      return new_const;
    }
  end

  def self.create_element(type, props = nil, children = nil, &block)
    %x{
      var component = null;
      var block_result = null;
      var native_props = null;

      if (typeof type.react_component == "function") {
        component = type.react_component;
      }
      else {
        component = type;
      }

      Opal.React.render_buffer.push([]);
      #{
        native_props = to_native_react_props(props) if props;
      }
      if (block !== nil) {
        block_result = block.$call()
        if (block_result && (typeof block_result.$$typeof == "undefined") && (#{`block_result` != nil})) {
          Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result);
        }
        children = Opal.React.render_buffer.pop()
        if (children.length == 1) { children = children[0]; }
        else if (children.length == 0) { children = null; }
      }
      return React.createElement(component, native_props, children);
    }
  end

  def self.create_factory(type)
    native_function = `React.createFactory(type)`
    proc { `native_function.call()` }
  end


  def self.create_ref
    React::Ref.new(`React.createRef()`)
  end

  def self.forwardRef(&block)
    # TODO whats the return here? A React:Element?, doc says a React node, whats that?
    `React.forwardRef( function(props, ref) { return block.$call().$to_n(); })`
  end

  def self.isValidElement(react_element)
    `React.isValidElement(react_element)`
  end
end