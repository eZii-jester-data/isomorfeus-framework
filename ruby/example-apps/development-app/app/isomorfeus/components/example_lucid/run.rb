module ExampleLucid
  class Run < LucidComponent::Base
    render do
      (props.match.count.to_i / 10).times do |i|
        AnotherLucidComponent(key: i)
      end
    end
  end
end