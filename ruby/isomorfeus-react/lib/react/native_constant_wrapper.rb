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
          Opal.React.internal_render(component, props, block);
        } else {
          return #{_original_method_missing(component_name, *args, block)};
        }
      }
    end
  end
end