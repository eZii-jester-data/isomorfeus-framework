module React
  module Server
    def self.render_to_string(element)
      React::RenderingContext.build { `ReactDOMServer.renderToString(#{element.to_n})` }
    end

    def self.render_to_static_markup(element)
      React::RenderingContext.build { `ReactDOMServer.renderToStaticMarkup(#{element.to_n})` }
    end
  end
end
