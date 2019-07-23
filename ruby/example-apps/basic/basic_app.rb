require_relative 'app_loader'
require_relative 'owl_init'
require_relative 'iodine_config'

class BasicApp < Roda
  include OpalWebpackLoader::ViewHelper
  plugin :public, root: 'public'

  def default_content
    <<~HTML
      <html>
        <head>
          <title>Welcome to BasicApp</title>
          #{owl_script_tag 'application.js'}
        </head>
        <body>
          <div></div>
        </body>
      </html>
    HTML
  end

  route do |r|
    r.root do
      default_content
    end

    r.public

    r.get do
      default_content
    end
  end
end
