class BasicApp < LucidApp::Base
  render do
    # here may be a router for example:
    # DIV do
    #   BrowserRouter do
    #     Switch do
    #       Route(path: '/fun/:count', exact: true, component: BasicComponent.JS[:react_component])
    #     end
    #   end
    # end

    # or a component:
    DIV do
      BasicComponent()
    end
  end
end