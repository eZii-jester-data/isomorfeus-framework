require 'opal'
require 'opal-autoloader'
require 'isomorfeus-redux'
require 'isomorfeus-transport-http'
require 'isomorfeus-record'
require 'isomorfeus-react'

Isomorfeus.client_transport_driver = Isomorfeus::Transport::HTTP

require_tree 'components'
require_tree 'models'

# some native React code for comparing performance
# language=JS
%x{
  var ExampleJS = {};
  global.ExampleJS = ExampleJS;

  class ExampleJSFun extends React.Component {
    constructor(props) {
      super(props);
    }
    render() {
      var rounds = parseInt(this.props.match.params.count);
      var result = [];
      for (var i = 0; i < rounds; i ++) {
        result.push(React.createElement(ExampleJS.AnotherComponent, {key: i}));
      }
      return result;
    }
  }
  ExampleJS.Fun = ExampleJSFun;

  class ExampleJSAnotherComponent extends React.Component {
    constructor(props) {
      super(props);
      this.show_orange_alert = this.show_orange_alert.bind(this);
      this.show_red_alert = this.show_red_alert.bind(this);
    }
    show_orange_alert() {
      alert("ORANGE ALERT!");
    }
    show_red_alert() {
      alert("RED ALERT!");
    }
    render() {
      return React.createElement(ExampleJS.AComponent, { onClick: this.show_orange_alert, text: 'Yes' },
        React.createElement("span", { onClick: this.show_red_alert }, 'Click for red alert! (Child 1), '),
        React.createElement("span", null, 'Child 2, '),
        React.createElement("span", null, 'etc. '),
      );
    }
  }
  ExampleJS.AnotherComponent = ExampleJSAnotherComponent;

  class ExampleJSAComponent extends React.Component {
    constructor(props) {
      super(props);
      this.state = { some_bool: true };
      this.change_state = this.change_state.bind(this);
    }
    change_state() {
      this.setState({some_bool: !this.state.some_bool});
    }
    render() {
      return [
        React.createElement("span", { onClick: this.props.onClick }, 'Click for orange alert! Props: '),
        React.createElement("span", null, this.props.text),
        React.createElement("span", { onClick: this.change_state }, ', State is: ' + (this.state.some_bool ? 'true' : 'false') + ' (Click!)'),
        React.createElement("span", null, ', Children: '),
        React.createElement("span", null, this.props.children),
        React.createElement("span", null, ' '),
        React.createElement("span", null, '| ')
      ];
    }
  }
  ExampleJS.AComponent = ExampleJSAComponent;

  class ExampleJSRun extends React.Component {
    constructor(props) {
      super(props);
    }
    render() {
      var rounds = parseInt(this.props.match.params.count)/10;
      var result = []
      for (var i = 0; i < rounds; i ++) {
        result.push(React.createElement(ExampleJS.AnotherComponent, {key: i}));
      }
      return result;
    }
  }
  ExampleJS.Run = ExampleJSRun;
}


Isomorfeus::TopLevel.on_ready_mount(MyApp)
