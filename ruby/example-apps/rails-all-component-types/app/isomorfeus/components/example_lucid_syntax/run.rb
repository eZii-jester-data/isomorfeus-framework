module ExampleLucidSyntax
  class Run < LucidComponent::Base
    render do
      (props.match.count.to_i / 12).times do |i|
        AnotherLucidComponent(key: i)
      end
    end
  end
end