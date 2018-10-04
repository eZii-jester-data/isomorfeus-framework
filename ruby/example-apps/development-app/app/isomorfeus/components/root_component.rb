class RootComponent < React::Component::Base
  event_handler :handle_click do |event, info|
    state.toggler = !state.toggler
  end

  state.toggler = false

  render do
    DIV do
      props.match.count.to_i.times do
        # Test()
        SPAN do
          'K'
        end
        SPAN do
          'B'
        end
        R1Component(icks: 'X') do
          SPAN { 'C' }
        end
        R1Component(icks: 'X') do
          'R'
        end
        R2Component()
        SPAN(on_click: :handle_click) do
          if state.toggler
            'Q'
          else
            'X'
          end
        end
        SPAN do
          's'
        end
        SPAN do
          's'
        end
        SPAN do
          's'
        end
        SPAN do
          's '
        end
      end
    end
  end

  component_did_mount do
    `console.log("Root mounted!")`
  end
end
