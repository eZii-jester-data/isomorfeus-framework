class AllTheFun < LucidComponent::Base
  render do
    DIV { ExampleFunction::AnotherFunComponent() }
    DIV { ExamplePure::AnotherPureComponent() }
    DIV { ExampleReact::AnotherComponent() }
    DIV { ExampleLucid::AnotherLucidComponent() }
    DIV { ExampleJS.AnotherComponent() }
  end
end