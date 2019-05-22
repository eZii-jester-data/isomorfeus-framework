class BasicComponent < LucidComponent::Base
  render do
    # when coming from the router example, get the count param:
    # props.match.count.to_i.times do |i|
    #   # showing the conveniently short 'string param syntax':
    #   DIV "Hello World!"
    # end

    # showing the 'block param syntax':
    DIV { "Hello World!" }
  end
end