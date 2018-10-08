module React
  module ReduxComponent
    module NativeComponent
      # for should_component_update we apply ruby semantics for comparing props
      # to do so, we convert the props to ruby hashes and then compare
      # this makes sure, that for example rubys Nil object gets handled properly
      def self.extended(base)
        component_name = base.to_s
        # language=JS
        %x{
          base.react_component = class extends React.Component {
            constructor(props) {
              super(props);
              if (base.$state().$size() > 0) {
                this.state = base.$state().$to_n();
              } else {
                this.state = {};
              };
              var current_store_state = Opal.Isomorfeus.store.native.getState();
              if (typeof current_store_state.__component_class_state !== "undefined" && typeof current_store_state.__component_class_state[#{component_name}] !== "undefined") {
                this.state.__component_class_state = {};
                this.state.__component_class_state[#{component_name}] = current_store_state.__component_class_state[#{component_name}];
              } else if (typeof this.state.__component_class_state === "undefined") {
                this.state.__component_class_state = {};
                this.state.__component_class_state[#{component_name}] = {};
              };
              this.__ruby_instance = base.$new(this);
              this.__object_id = this.__ruby_instance.$object_id().$to_s();
              if (!this.state.__component_state) {
                this.state.__component_state = {};
                this.state.__component_state[this.__object_id] = {};
              };
              var event_handlers = #{base.event_handlers};
              var evh_length = event_handlers.length;
              for (var i = 0; i < evh_length; i++) {
                this[event_handlers[i]] = this[event_handlers[i]].bind(this);
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
              this.listener = this.listener.bind(this);
              this.unsubscriber = Opal.Isomorfeus.store.native.subscribe(this.listener);
            }
            static get displayName() {
              return #{component_name};
            }
            shouldComponentUpdate(next_props, next_state) {
              if (base.has_custom_should_component_update) {
                return this.__ruby_instance["$should_component_update"](#{self.React::Component::Props.new(Hash.new(next_props))}, #{Hash.new(next_state)});
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
                    else if (typeof next_props[property] !== "undefined" && typeof next_props[property]['$!='] !== "undefined" && typeof this.props[property] !== "undefined" && typeof this.props[property]['$!='] !== "undefined") {
                      if (#{ !! (`next_props[property]` != `this.props[property]`) }) { return true; };
                    } else if (next_props[property] !== this.props[property]) { return true; };
                  }
                }
                for (var property in next_state) {
                  if (next_state.hasOwnProperty(property)) {
                    if (!this.state.hasOwnProperty(property)) { return true; };
                    if (typeof next_state[property]['$!='] !== "undefined" && typeof this.state[property]['$!='] !== "undefined") {
                      if (#{ !! (`next_state[property]` != `this.state[property]`) }) { return true };
                    } else if (next_state[property] !== this.state[property]) { return true };
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
            listener() {
              var next_state = Opal.Isomorfeus.store.native.getState();
              if (typeof next_state.__component_state !== "undefined" && typeof next_state.__component_state[this.__object_id] !== "undefined") {
                var current_ruby_state = Opal.Hash.$new(this.state.__component_state[this.__object_id]);
                var next_ruby_state = Opal.Hash.$new(next_state.__component_state[this.__object_id]);
                if (#{`next_ruby_state` != `current_ruby_state`}) {
                  var new_state = { __component_state: {}};
                  new_state.__component_state[this.__object_id] = current_ruby_state.$merge(next_ruby_state).$to_n();
                  this.setState(new_state);
                }
              }
              if (typeof next_state.__component_class_state !== "undefined" && typeof next_state.__component_class_state[#{component_name}] !== "undefined") {
                var current_ruby_state = Opal.Hash.$new(this.state.__component_class_state[#{component_name}]);
                var next_ruby_state = Opal.Hash.$new(next_state.__component_class_state[#{component_name}]);
                if (#{`next_ruby_state` != `current_ruby_state`}) {
                  var new_state = { __component_class_state: {}};
                  new_state.__component_class_state[#{component_name}] = current_ruby_state.$merge(next_ruby_state).$to_n();
                  this.setState(new_state);
                }
              }
            }
            componentWillUnmount() {
              if (typeof this.unsubscriber === "function") { this.unsubscriber(); };
            }
          }
        }
      end
    end
  end
end
