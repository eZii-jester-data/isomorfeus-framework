require_relative 'app_loader'
require_relative 'owl_init'
require_relative 'iodine_config'

class BasicApp < Roda
  include OpalWebpackLoader::ViewHelper
  include Isomorfeus::ReactViewHelper
  plugin :public, root: 'public'

  def page_content(host, location)
    <<~HTML
      <html>
        <head>
          <title>Welcome to AllComponentTypesApp</title>
          #{owl_script_tag 'application.js'}
        </head>
        <body>
          #{mount_component('BasicApp', location_host: host, location: location)}
        </body>
      </html>
    HTML
  end

  route do |r|
    r.root do
      page_content(env['HTTP_HOST'], '/')
    end

    r.public

    r.get 'favicon.ico' do
      r.public
    end

    r.get do
      page_content(env['HTTP_HOST'], env['PATH_INFO'])
    end
  end
end
