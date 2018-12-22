module ExampleRedux
  class Fun < React::ReduxComponent::Base
    render do
      props.match.count.to_i.times do |i|
        AnotherReduxComponent(key: i)
      end
    end
  end
end