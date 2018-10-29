class React::FunctionComponent::Creator
  event_handler :show_red_alert do |event|
    `alert("RED ALERT!")`
  end

  event_handler :show_orange_alert do |event|
    `alert("ORANGE ALERT!")`
  end

  function_component 'AFunComponent' do
    SPAN(on_click: props.on_click) { 'Click for orange alert! Props: ' }
    SPAN { props.text }
    SPAN { ', Children: '  }
    SPAN { props.children }
    SPAN { ' ' }
    SPAN { '| '}
  end

  function_component 'AnotherFunComponent' do
    AFunComponent(on_click: :show_orange_alert, text: 'Yes') do
      SPAN(on_click: :show_red_alert) { 'Click for red alert! (Child 1), ' }
      SPAN { 'Child 2, '}
      SPAN { 'Child 3, '}
      SPAN { 'etc. '}
    end
  end

  function_component 'ExampleFunction.Fun' do
    props.match.count.to_i.times do |i|
      AnotherFunComponent(key: i)
    end
  end

  function_component 'ExampleFunction.Run' do
    (props.match.count.to_i / 10).times do |i|
      AnotherFunComponent(key: i)
    end
  end
end