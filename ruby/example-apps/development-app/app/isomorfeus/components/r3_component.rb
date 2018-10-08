class R3Component < React::ReduxComponent::Base
  event_handler :handle_click do |event, info|
    `console.log('received click hc')`
    store.toggler = !store.toggler
  end

  event_handler :another_handle_click do |event, info|
    `console.log('received click ahc')`
    class_store.toggler = !class_store.toggler
  end

  class_store.why = 'Y'
  class_store.toggler = false

  prop :icks, class: String

  render do
    SPAN(on_click: :handle_click) do
      if store.toggler
        props.icks
      else
        props.children
      end
    end
    SPAN(on_click: :another_handle_click) do
      if class_store.toggler
        class_store.why
      else
        props.children
      end
    end
  end
end