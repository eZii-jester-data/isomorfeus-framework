module ExamplePure
  class Fun < React::PureComponent::Base
    render do
      props.match.count.to_i.times do |i|
        AnotherPureComponent(key: i)
      end
    end
  end
end