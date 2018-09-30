module React
  module Component
    module Resolution
      def self.included(base)
        base.instance_exec do
          alias _original_const_missing const_missing

          def const_missing(const_name)
            %x{
              if (typeof Opal.global[const_name] == "object") {
                var new_const = #{React::NativeConstantWrapper.new(`Opal.global[const_name]`)};
                #{Object.const_set(const_name, `new_const`)};
                return new_const;
              } else {
                return #{_original_method_missing(const_name)};
              }
            }
          end
        end
      end

      alias _original_method_missing method_missing

      def method_missing(component_name, *args, &block)
        # html tags are defined as methods, so they will not end up here.
        # first check for native component and render it, we want to be fast for native components
        # second check for ruby component and render it, they are a bit slower anyway
        # third pass on method missing

        %x{
          var component = null;
          if (typeof Opal.global[component_name] == "function") {
            component = Opal.global[component_name];
          }
          else {
            try {
              var constant = self.$class().$const_get(component_name, true);
              if (typeof constant.react_component == "function") {
                component = constant.react_component;
              }
            }
            catch(err) {
              component = null;
            }
          }
          if (component) {
            var children = null;
            var block_result = null;
            var props = null;
            Opal.React.render_buffer.push([]);
            if (args.length > 0) {
              props = #{to_native_react_props(args[0])};
            }
            if (block !== nil) {
              block_result = block.$call()
              if (block_result && (#{`block_result` != nil})) {
                Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(block_result);
              }
            }
            var element = React.createElement(component, props, Opal.React.render_buffer.pop());
            Opal.React.render_buffer[Opal.React.render_buffer.length - 1].push(element);
            return null;
          } else {
            return #{_original_method_missing(component_name, *args, block)};
          }
        }
      end

    end
  end
end