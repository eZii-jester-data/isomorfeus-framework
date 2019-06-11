module ExampleFunction
  class Fun < React::FunctionComponent::Base
    create_function do
      props.match.count.to_i.times do |i|
        AnotherFunComponent(key: i)
      end
    end
  end
end