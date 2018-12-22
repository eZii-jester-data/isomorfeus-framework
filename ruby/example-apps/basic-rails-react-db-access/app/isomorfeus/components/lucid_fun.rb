class LucidFun < LucidComponent::Base
  render do
    props.match.count.to_i.times do |i|
      LucidExample(key: i)
    end
  end
end
