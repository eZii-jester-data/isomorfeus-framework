require 'opal'
require 'opal-autoloader'
require 'isomorfeus-react'

require_tree 'components'

class React::FunctionalComponent::Creator
  functional_component 'R2Component' do
    Fragment do
      SPAN { "f" }
    end
  end
end

%x{
  class Tester extends React.Component {
    constructor(props) {
      super(props);
      this.handle_click = this.handle_click.bind(this);
      this.state = { toggle: false };
    }
    handle_click() {
      this.setState({ toggle: !this.state.toggle });
    }
    render() {
      var t;
      if (this.state.toggle) {
        t = "XX";
      } else {
        t = "OO";
      }
      return React.createElement(
        "div",
        null,
        React.createElement(
          "div",
          null,
          "RR"
        ),
        React.createElement(
          "div",
          { onClick: this.handle_click },
          t
        ),
        React.createElement(
          "div",
          null,
          "SS"
        )
      );
    }
  }
  global.Tester = Tester;

  class Test extends React.Component {
    constructor(props) {
      super(props);
      this.handle_click = this.handle_click.bind(this);
      this.state = { toggle: false };
    }
    handle_click() {
      this.setState({ toggle: !this.state.toggle });
    }
    render() {
      var t;
      if (this.state.toggle) {
        t = "X";
      } else {
        t = "O";
      }
      return React.createElement(
        "div",
        null,
        React.createElement(
          "div",
          null,
          "R"
        ),
        React.createElement(
          "div",
          { onClick: this.handle_click },
          t
        ),
        React.createElement(
          "div",
          null,
          "S"
        ),
        React.createElement(Tester, null)
      );
    }
  }
  global.Test = Test;

  function do_the_mount() {
    //var c = React.createElement(Ahh, null, null);
    //return ReactDOM.render(c, document.body.querySelector('div'));
    var t1 = performance.now();
    #{ReactDOM.render(React.create_element(RootComponent), `document.body.querySelector('div')`)};
    var t2 = performance.now();
    console.log(t2 - t1);
  };
  function ready_fun() {
    /in/.test(document.readyState) ? setTimeout(ready_fun,5) : do_the_mount();
  };
  ready_fun();
}
