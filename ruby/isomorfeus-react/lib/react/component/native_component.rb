module React
  module Component
    module NativeComponent
      # for should_component_update we apply ruby semantics for comparing props
      # to do so, we convert the props to ruby hashes and then compare
      # this makes sure, that for example rubys Nil object gets handled properly
      def self.extended(base)
        component_name = base.to_s
        %x{
          base.react_component = class extends React.Component {
            constructor(props) {
              super(props);
              this.state = base.$state().$to_n();
              this.__ruby_instance = base.$new(this);
              var here = this;
              #{
                base.event_handlers.each do |handler|
                  `here[handler] = here[handler].bind(here);`
                end
              }
            }
            static get displayName() {
              return #{component_name};
            }
            shouldComponentUpdate(next_props, next_state) {
              if (base.has_custom_should_component_update) {
                return this.__ruby_instance["$should_component_update"](#{self.to_ruby_props(Hash.new(next_props))}, #{Hash.new(next_state)});
              } else {
                var next_props_keys = Object.keys(next_props);
                var this_props_keys = Object.keys(this.props);
                if (next_props_keys.length !== this_props_keys.length) { return true; }

                var next_state_keys = Object.keys(next_state);
                var this_state_keys = Object.keys(this.state);
                if (next_state_keys.length !== this_state_keys.length) { return true; }

                for (var property in next_props) {
                  if (next_props.hasOwnProperty(property)) {
                    if (!this.props.hasOwnProperty(property)) { return true; };
                    if (property == "children") { if (next_props.children !== this.props.children) { return true; }}
                    else if (#{ !! (`next_props[property]` != `this.props[property]`) }) { return true; };
                  }
                }
                for (var property in next_state) {
                  if (next_state.hasOwnProperty(property)) {
                    if (!this.state.hasOwnProperty(property)) { return true; };
                    if (#{ !! (`next_state[property]` != `this.state[property]`) }) { return true };
                  }
                }
                return false;
              }
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
