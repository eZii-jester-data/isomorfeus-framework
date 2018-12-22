require 'opal'
require 'opal-autoloader'
require 'isomorfeus-redux'
require 'isomorfeus-react'

require_tree 'components'

Isomorfeus::TopLevel.on_ready_mount(MyApp)
