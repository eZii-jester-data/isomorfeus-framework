class AllTheFun < LucidComponent::Base
  render do
    DIV { AnotherFunComponent() }
    DIV { ExamplePure::AnotherPureComponent() }
    DIV { ExampleReact::AnotherComponent() }
    DIV { ExampleRedux::AnotherReduxComponent() }
    DIV { ExampleLucid::AnotherLucidComponent() }
    DIV { ExampleJS.AnotherComponent() }
  end
end