require 'set'
require 'isomorfeus-store/base_store_class'
require 'isomorfeus-store/class_methods'
require 'isomorfeus-store/dispatch_receiver'
require 'isomorfeus-store/instance_methods'
require 'isomorfeus-store/mutator_wrapper'
require 'isomorfeus-store/state_wrapper/argument_validator'
require 'isomorfeus-store/state_wrapper'
require 'isomorfeus/store'
require 'isomorfeus/application/boot'
require 'isomorfeus/store/mixin'
require 'react/state'

if RUBY_ENGINE != 'opal'
  require 'opal'
  Opal.append_path(__dir__.untaint)
  if Dir.exist?(File.join('app', 'isomorfeus'))
    # Opal.append_path(File.expand_path(File.join('app', 'isomorfeus', 'stores')))
    Opal.append_path(File.expand_path(File.join('app', 'isomorfeus'))) unless Opal.paths.include?(File.expand_path(File.join('app', 'isomorfeus')))
  elsif Dir.exist?(File.join('isomorfeus'))
    # Opal.append_path(File.expand_path(File.join('isomorfeus', 'stores')))
    Opal.append_path(File.expand_path(File.join('isomorfeus'))) unless Opal.paths.include?(File.expand_path(File.join('isomorfeus')))
  end
end
