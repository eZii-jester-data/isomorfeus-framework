module ExampleRedux
  class Run < React::ReduxComponent::Base
    render do
      (props.match.count.to_i / 12).times do |i|
        AnotherReduxComponent(key: i)
      end
    end
  end
end