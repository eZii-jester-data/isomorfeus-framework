class MyApp < LucidApp::Base
  render do
    DIV do
      BrowserRouter do
        Switch do
          Route(path: '/fun_fun/:count', exact: true, component: `ExampleFunction.Fun`)
          Route(path: '/fun_run/:count', exact: true, component: `ExampleFunction.Run`)
          Route(path: '/pure_fun/:count', exact: true, component: ExamplePure::Fun.JS[:react_component])
          Route(path: '/pure_run/:count', exact: true, component: ExamplePure::Run.JS[:react_component])
          Route(path: '/com_fun/:count', exact: true, component: ExampleReact::Fun.JS[:react_component])
          Route(path: '/com_run/:count', exact: true, component: ExampleReact::Run.JS[:react_component])
          Route(path: '/red_fun/:count', exact: true, component: ExampleRedux::Fun.JS[:react_component])
          Route(path: '/red_run/:count', exact: true, component: ExampleRedux::Run.JS[:react_component])
          Route(path: '/luc_fun/:count', exact: true, component: ExampleLucid::Fun.JS[:react_component])
          Route(path: '/luc_run/:count', exact: true, component: ExampleLucid::Run.JS[:react_component])
          Route(path: '/lucs_fun/:count', exact: true, component: ExampleLucid::Jogging.JS[:react_component])
          Route(path: '/lucs_run/:count', exact: true, component: ExampleLucid::Jogging.JS[:react_component])
          Route(path: '/lucsy_fun/:count', exact: true, component: ExampleLucidSyntax::Fun.JS[:react_component])
          Route(path: '/lucsy_run/:count', exact: true, component: ExampleLucidSyntax::Run.JS[:react_component])
          Route(path: '/lucssy_fun/:count', exact: true, component: ExampleLucidSyntax::Jogging.JS[:react_component])
          Route(path: '/lucssy_run/:count', exact: true, component: ExampleLucidSyntax::Jogging.JS[:react_component])
          Route(path: '/js_fun/:count', exact: true, component: `ExampleJS.Fun`)
          Route(path: '/js_run/:count', exact: true, component: `ExampleJS.Run`)
          Route(path: '/all_the_fun/:count', exact: true, component: AllTheFun.JS[:react_component])
          Route(path: '/', strict: true, component: ShowLinks.JS[:react_component])
        end
      end
    end
  end
end
