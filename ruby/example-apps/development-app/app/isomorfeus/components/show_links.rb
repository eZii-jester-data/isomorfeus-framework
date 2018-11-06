class ShowLinks < React::PureComponent::Base
  render do
    H2 { 'Functionality' }
    DIV do
      H3 { 'React::ReduxComponent, LucidRecord:' }
      Link(to: '/redux_fun/1') { 'Render' }
    end
    DIV do
      H3 { 'LucidComponent, LucidRecord:' }
      Link(to: '/lucid_fun/1') { 'Render'  }
    end
    H2 { 'Performance' }
    DIV do
      H3 { 'React::ReduxComponent, LucidRecord:' }
      Link(to: '/redux_fun/10') { 'Render 10 times' }
      SPAN { ' | ' }
      Link(to: '/redux_fun/100') { 'Render 100 times' }
    end
    DIV do
      H3 { 'LucidComponent, LucidRecord:' }
      Link(to: '/lucid_fun/10') { 'Render 10 times' }
      SPAN { ' | ' }
      Link(to: '/lucid_fun/100') { 'Render 100 times' }
    end
  end
end