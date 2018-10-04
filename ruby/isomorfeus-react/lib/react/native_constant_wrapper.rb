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
          var react_element;

          if (args.length > 0) {
            props = #{to_native_react_props(args[0])};
          }
          if (name == 'Consumer') {
            var react_element = React.createElement(component, props, function(value) {
              if (block !== nil) {
                Opal.React.render_buffer.push([]);
                block_result = block.$call();
                if (block_result && (typeof block_result['$!='] !== "undefined" && #{`block_result` != nil})) {
                  Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result);
                }
                children = Opal.React.render_buffer.pop();
                if (children.length == 1) { children = children[0]; }
                else if (children.length == 0) { children = null; }
              }
              return Opal.React.render_buffer.pop();
            });
            Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(react_element);
          } else {
            if (block !== nil) {
              Opal.React.render_buffer.push([]);
              block_result = block.$call();
              if (block_result && (typeof block_result['$!='] !== "undefined" && #{`block_result` != nil})) {
                Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result);
              }
              children = Opal.React.render_buffer.pop();
              if (children.length == 1) { children = children[0]; }
              else if (children.length == 0) { children = null; }
            }
            react_element = React.createElement(component, props, children);
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