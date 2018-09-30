module React
  class NativeConstantWrapper
    include ::Native::Wrapper
    include ::React::PropsConverters

    alias _original_method_missing method_missing

    def method_missing(name, *args, &block)
      %x{
        var component = null;
        if (typeof #@native[name] == "function") {
          component = #@native[name];
        }

        if (component) {
          var children = null;
          var block_result = null;
          var props = null;

          if (args.length > 0) {
            props = #{to_native_react_props(args[0])};
          }
          if (name == 'Consumer') {
            var react_element = React.createElement(component, props, function(value) {
              Opal.React.render_buffer.push([]);
              if (block !== nil) {
                block_result = block.$call(value)
                if (block_result && (#{`block_result` != nil})) {
                  Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result);
                }
              }
              return Opal.React.render_buffer.pop();
            });
            Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(react_element);
          } else {
            Opal.React.render_buffer.push([]);
            if (block !== nil) {
              block_result = block.$call()
              if (block_result && (#{`block_result` != nil})) {
                Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result);
              }
            }
            var react_element = React.createElement(component, props, Opal.React.render_buffer.pop());
            Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(react_element);
          }
          return null;
        } else {
          return #{_original_method_missing(component_name, *args, block)};
        }
      }
    end
  end
end