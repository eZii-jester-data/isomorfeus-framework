class AllTheFun < LucidComponent::Base
  render do
    DIV { ExampleFunction::AnotherFunComponent() }
    DIV { ExampleReact::AnotherComponent() }
    DIV { ExampleLucid::AnotherLucidComponent() }
    DIV { ExampleJS.AnotherComponent() }
  end
end
