class MyDream < LucidComponent::Base
  event_handler :handle_click do |event, info|
    `console.log('received click hc')`
    store.toggler = !store.toggler
  end

  event_handler :another_handle_click do |event, info|
    `console.log('received click ahc')`
    class_store.toggler = !class_store.toggler
  end

  event_handler :yeah_handle_click do |event, info|
    `console.log('received click ahc')`
    app_store.yeah = !app_store.yeah
  end

  class_store.why = 'Y'
  class_store.toggler = false
  app_store.yeah = false

  prop :icks, class: String

  render do
    SPAN do
      UL do
        MyModel.all.each do |model|
          LI(key: model.id) { model.name }
        end
      end
    end
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
    SPAN(on_click: :yeah_handle_click) do
      if app_store.yeah
        'YEAH!'
      else
        'NOOO!'
      end
    end
    SPAN { ' ' }
  end
end