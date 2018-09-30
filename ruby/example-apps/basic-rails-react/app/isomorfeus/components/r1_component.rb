class R1Component < React::Component::Base
  event_handler :handle_click do |event, info|
    state.toggler = !state.toggler
  end

  state.toggler = false

  prop :icks, class: String

  render do
    SPAN(on_click: :handle_click) do
      if state.toggler
        props.icks
      else
        props.children
      end
    end
  end
end