module React
  module PureComponent
    module NativeComponent
      def self.extended(base)
        component_name = base.to_s
        %x{
          base.react_component = class extends React.Component {
            constructor(props) {
              super(props);
              this.state = base.$state().$to_n();
              this.__ruby_instance = base.$new(this);
              var event_handlers = #{base.event_handlers};
              var evh_length = event_handlers.length;
              for (var i = 0; i < evh_length; i++) {
                this[event_handlers[i]] = this[event_handlers[i]].bind(here);
              }
              var defined_refs = #{base.defined_refs};
              for (var ref in defined_refs) {
                if (defined_refs[ref] != null) {
                  this[ref] = function(element) {
                    #{`this.__ruby_instance`.instance_exec(React::Ref.new(`element`), `defined_refs[ref]`)}
                  }
                  this[ref] = this[ref].bind(this);
                } else {
                  this[ref] = React.createRef();
                }
              }
            }
            static get displayName() {
              return #{component_name};
            }
            validateProp(props, propName, componentName) {
              var prop_data = base.react_component.propValidations[propName];
              if (!prop_data) { return true; };
              var value = props[propName];
              var result;
              if (typeof prop_data.ruby_class != "undefined") {
                result = (value.$class() == prop_data.ruby_class);
                if (!result) {
                  return new Error('Invalid prop ' + propName + '! Expected ' + prop_data.ruby_class.$to_s() + ' but was ' + value.$class().$to_s() + '!');
                }
              } else if (typeof prop_data.is_a != "undefined") {
                result = value["$is_a?"](prop_data.is_a);
                if (!result) {
                  return new Error('Invalid prop ' + propName + '! Expected a child of ' + prop_data.is_a.$to_s() + '!');
                }
              }
              if (typeof prop_data.required != "undefined") {
                if (prop_data.required && (typeof props[propName] == "undefined")) {
                  return new Error('Prop ' + propName + ' is required but not given!');
                }
              }
              return null;
            }
          }
        }
      end
    end
  end
end
