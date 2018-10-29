module ExamplePure
  class Run < React::PureComponent::Base
    render do
      (props.match.count.to_i / 10).times do |i|
        AnotherPureComponent(key: i)
      end
    end
  end
end