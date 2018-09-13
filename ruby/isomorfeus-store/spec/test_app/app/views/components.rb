require 'opal'
require 'isomorfeus-component'
if React::IsomorphicHelpers.on_opal_client?
  require 'browser'
  require 'browser/delay'
end
require 'isomorfeus-store'

require_tree './components'
