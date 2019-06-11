require './app_loader'
require './owl_init'

class AllComponentTypesApp < Roda
  include OpalWebpackLoader::ViewHelper
  include Isomorfeus::ReactViewHelper

  plugin :public, root: 'public'

  def page_content(location)
    <<~HTML
      <html>
        <head>
          <title>Welcome to AllComponentTypesApp</title>
          #{owl_script_tag 'application.js'}
        </head>
        <body>
          #{mount_component('MyApp', location: location)}
        </body>
      </html>
    HTML
  end

  route do |r|
    r.root do
      page_content('/')
    end

    r.public

    r.get 'favicon.ico' do
      r.public
    end

    r.get do
      page_content(env['REQUEST_PATH'])
    end
  end
end
