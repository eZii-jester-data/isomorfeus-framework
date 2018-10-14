if RUBY_ENGINE == 'opal'
  require 'native'
  require 'promise'
  require 'redux/version'
  require 'redux'
  require 'redux/store'
  # store initialization happens in Isomorfeus.init, see isomorfeus-react/lib/isomorfeus/config.rb
else
  require 'opal'
  require 'isomorfeus/promise'
  require 'redux/version'

  Opal.append_path(__dir__.untaint)

  if Dir.exist?(File.join('app', 'isomorfeus'))
    # Opal.append_path(File.expand_path(File.join('app', 'isomorfeus', 'components')))
    Opal.append_path(File.expand_path(File.join('app', 'isomorfeus'))) unless Opal.paths.include?(File.expand_path(File.join('app', 'isomorfeus')))
  elsif Dir.exist?('isomorfeus')
    # Opal.append_path(File.expand_path(File.join('isomorfeus', 'components')))
    Opal.append_path(File.expand_path('isomorfeus')) unless Opal.paths.include?(File.expand_path('isomorfeus'))
  end
end