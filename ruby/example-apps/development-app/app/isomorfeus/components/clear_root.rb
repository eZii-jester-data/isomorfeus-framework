class ClearRoot < React::Component::Base
  event_handler :handle_click do |event, info|
    state.toggler = !state.toggler
  end

  state.toggler = false

  render do
    DIV do
      props.match.count.to_i.times do
        # Test()
        MyDream(icks: 'X') do
          'R'
        end
      end
    end
  end

  component_did_mount do
    `console.log("Root mounted!")`
  end
end