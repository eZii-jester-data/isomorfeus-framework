class MyApp < LucidApp::Base
  render do
    DIV do
      BrowserRouter do
        Switch do
          Route(path: '/redux_fun/:count', exact: true, component: ReduxFun.JS[:react_component])
          Route(path: '/lucid_fun/:count', exact: true, component: LucidFun.JS[:react_component])
          Route(path: '/', strict: true, component: ShowLinks.JS[:react_component])
        end
      end
    end
  end
end
