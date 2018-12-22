# cat config.ru
require "roda"
require "isomorfeus-redux"
require "isomorfeus-react"

class App < Roda
  route do |r|
    # GET / request
    r.root do
      <<~HTML
      <html>
      <head>
        <title>Roda + Isomorfeus!</title>
        <script src="http://localhost:3035/packs/app_development.js"></script>
      </head>
      <body>
        <div></div>
      </body>
      </html>
      HTML
    end
  end
end

run App.freeze.app