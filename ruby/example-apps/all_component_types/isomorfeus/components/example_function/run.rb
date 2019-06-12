module ExampleFunction
  class Run < React::FunctionComponent::Base
    create_function do
      (props.match.count.to_i / 10).times do |i|
        ExampleFunction::AnotherFunComponent(key: i)
      end
    end
  end
end