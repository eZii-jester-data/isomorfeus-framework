module React
  module Component
    # class level methods (macros) for components
    module ClassMethods

      def deprecation_warning(message)
        React::Component.deprecation_warning(self, message)
      end

      def react_component?
        true
      end

      def backtrace(*args)
        @dont_catch_exceptions = (args[0] == :none)
        @backtrace_off = @dont_catch_exceptions || (args[0] == :off)
      end

      def append_backtrace(message_array, backtrace)
        message_array << "    #{backtrace[0]}"
        backtrace[1..-1].each { |line| message_array << line }
      end

      def render(container = nil, params = {}, &block)
        if container
          container = container.type if container.is_a? React::Element
          define_method :render do
            React::RenderingContext.render(container, params) { instance_eval(&block) if block }
          end
        else
          define_method(:render) { instance_eval(&block) }
        end
      end

      # method missing will assume the method is a class name, and will treat this a render of
      # of the component, i.e. Foo::Bar.baz === Foo::Bar().baz

      def method_missing(name, *args, &children)
        Object.method_missing(name, *args, &children) unless args.empty?
        React::RenderingContext.render(
          self, class: React::Element.haml_class_name(name), &children
        )
      end

      def prop_types
        if self.validator
          {
            _componentValidator: %x{
              function(props, propName, componentName) {
                var errors = #{validator.validate(Hash.new(`props`))};
                return #{`errors`.count > 0 ? `new Error(#{"In component `#{name}`\n" + `errors`.join("\n")})` : `undefined`};
              }
            }
          }
        else
          {}
        end
      end

      def native_mixin(item)
        native_mixins << item
      end

      def native_mixins
        @native_mixins ||= []
      end

      def static_call_back(name, &block)
        static_call_backs[name] = block
      end

      def static_call_backs
        @static_call_backs ||= {}
      end

      def export_component(opts = {})
        export_name = (opts[:as] || name).split('::')
        first_name = export_name.first
        Native(`Opal.global`)[first_name] = add_item_to_tree(
          Native(`Opal.global`)[first_name],
          [React::API.create_native_react_class(self)] + export_name[1..-1].reverse
        ).to_n
      end

      def imports(component_name)
        React::API.import_native_component(
          self, React::API.eval_native_react_component(component_name)
        )
        define_method(:render) {} # define a dummy render method - will never be called...
      rescue Exception => e # rubocop:disable Lint/RescueException : we need to catch everything!
        raise "#{self} cannot import '#{component_name}': #{e.message}."
        # rubocop:enable Lint/RescueException
      ensure
        self
      end

      def add_item_to_tree(current_tree, new_item)
        if Native(current_tree).class != Native::Object || new_item.length == 1
          new_item.inject { |a, e| { e => a } }
        else
          Native(current_tree)[new_item.last] = add_item_to_tree(
            Native(current_tree)[new_item.last], new_item[0..-2]
          )
          current_tree
        end
      end

      def to_n
        native_component = React::API.class_variable_get(:@@component_classes)[self]
        return native_component if native_component
        React::API.create_native_react_class(self)
      end
    end
  end
end
