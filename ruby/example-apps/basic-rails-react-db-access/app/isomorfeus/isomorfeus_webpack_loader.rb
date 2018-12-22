require 'opal'
require 'opal-autoloader'
require 'isomorfeus-redux'
require 'isomorfeus-transport-http'
require 'isomorfeus-record'
require 'isomorfeus-react'

Isomorfeus.client_transport_driver = Isomorfeus::Transport::HTTP

require_tree 'components'
require_tree 'models'

Isomorfeus::TopLevel.on_ready_mount(MyApp)
