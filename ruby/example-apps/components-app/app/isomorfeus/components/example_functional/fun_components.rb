class React::FunctionalComponent::Creator
  event_handler :show_red_alert do |event|
    `alert("RED ALERT!")`
  end

  event_handler :show_orange_alert do |event|
    `alert("ORANGE ALERT!")`
  end

  functional_component 'AFunComponent' do
    SPAN(on_click: props.on_click) { 'Click for orange alert! Props: ' }
    SPAN { props.text }
    SPAN { ', Children: '  }
    SPAN { props.children }
    SPAN { ' ' }
    SPAN { '| '}
  end

  functional_component 'AnotherFunComponent' do
    AFunComponent(on_click: :show_orange_alert, text: 'Yes') do
      SPAN(on_click: :show_red_alert) { 'Click for red alert! (Child 1), ' }
      SPAN { 'Child 2, '}
      SPAN { 'Child 3, '}
      SPAN { 'etc. '}
    end
  end

  functional_component 'ExampleFunctional.Fun' do
    props.match.count.to_i.times do |i|
      AnotherFunComponent(key: i)
    end
  end

  functional_component 'ExampleFunctional.Run' do
    (props.match.count.to_i / 10).times do |i|
      AnotherFunComponent(key: i)
    end
  end
end