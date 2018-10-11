require 'opal'
require 'opal-autoloader'
require 'isomorfeus-redux'
require 'isomorfeus-react'

require_tree 'components'

class React::FunctionalComponent::Creator
  functional_component 'R2Component' do
    Fragment do
      SPAN { "f" }
    end
  end
end

# some native React code for comparing performance
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
}

class ShowLinks < React::PureComponent::Base
  render do
    DIV do
      SPAN { 'Props based Redux Components: ' }
      Link(to: '/run/10') { 'Run 10' }
      SPAN { ' | ' }
      Link(to: '/run/100') { 'Run 100' }
      SPAN { ' | ' }
      Link(to: '/run/1000') { 'Run 1000' }
      SPAN { ' | ' }
      Link(to: '/run/1000') { 'Run 3000' }
      SPAN { ' | ' }
      Link(to: '/run/10000') { 'Run 10000' }
    end
    DIV do
      SPAN { 'State based Redux Components: ' }
      Link(to: '/rrun/10') { 'Run 10' }
      SPAN { ' | ' }
      Link(to: '/rrun/100') { 'Run 100' }
      SPAN { ' | ' }
      Link(to: '/rrun/1000') { 'Run 1000' }
      SPAN { ' | ' }
      Link(to: '/rrun/1000') { 'Run 3000' }
      SPAN { ' | ' }
      Link(to: '/rrun/10000') { 'Run 10000' }
    end
  end
end

class RouterComponent < React::Component::Base
  render do
    DIV do
      BrowserRouter do
        Switch do
          Route(path: '/run/:count', exact: true, component: RootComponent.JS[:react_component])
          Route(path: '/', strict: true, component: ShowLinks.JS[:react_component])
        end
      end
    end
  end
end

Isomorfeus::TopLevel.on_ready_mount(MyApp)
