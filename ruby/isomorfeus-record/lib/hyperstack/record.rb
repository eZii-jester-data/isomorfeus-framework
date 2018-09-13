module Isomorfeus::Record
  # keep this for autoloader happiness
end

if RUBY_ENGINE == 'opal'
  require 'isomorfeus/record/dummy_value'
  require 'isomorfeus/record/collection'
  require 'isomorfeus/record/client_class_methods'
  require 'isomorfeus/record/client_class_processor'
  require 'isomorfeus/record/client_instance_methods'
  require 'isomorfeus/record/client_instance_processor'
  require 'isomorfeus/record/mixin'
  require 'isomorfeus/record/base'
else
  require 'isomorfeus/record/server_class_methods'
  require 'isomorfeus/record/server_instance_methods'
  require 'isomorfeus/record/mixin'
  require 'isomorfeus/record/base'
end
