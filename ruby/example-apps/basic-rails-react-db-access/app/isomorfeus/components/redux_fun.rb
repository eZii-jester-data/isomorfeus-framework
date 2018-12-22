class ReduxFun < React::ReduxComponent::Base
  render do
    props.match.count.to_i.times do |i|
      ReduxExample(key: i)
    end
  end
end