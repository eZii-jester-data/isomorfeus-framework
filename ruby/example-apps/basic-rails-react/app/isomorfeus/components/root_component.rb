class RootComponent < React::Component::Base
  event_handler :handle_click do |event, info|
    state.toggler = !state.toggler
  end

  state.toggler = false

  render do
    Sem.Container(text_align: 'left', text: true) do
      1000.times do
        # Test()
        Sem.Label(as: 'span') do
          'l'
        end
        Sem.Label(as: 'span') do
          'l'
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
            'O'
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
          's '
        end
      end
    end
  end

  component_did_mount do
    `console.log("Root mounted!")`
  end
end