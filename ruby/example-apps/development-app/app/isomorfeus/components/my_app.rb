class MyApp < Lucid::App::Base
  render do
    DIV do
      BrowserRouter do
        Switch do
          Route(path: '/run/:count', exact: true, component: ClearRoot.JS[:react_component])
          Route(path: '/rrun/:count', exact: true, component: RootComponent.JS[:react_component])
          Route(path: '/', strict: true, component: ShowLinks.JS[:react_component])
        end
      end
    end
  end
end