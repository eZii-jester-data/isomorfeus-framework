require 'isomorfeus-transport'
require 'isomorfeus/data/config'
require 'isomorfeus/data/props'
require 'isomorfeus/data/generic_class_api'
require 'isomorfeus/data/generic_instance_api'
require 'isomorfeus/data/element_validator'
require 'lucid_array/mixin'
require 'lucid_array/base'
require 'lucid_hash/mixin'
require 'lucid_hash/base'
require 'lucid_arango/edge/mixin'
require 'lucid_arango/edge/base'
require 'lucid_arango/document/mixin'
require 'lucid_arango/document/base'
require 'lucid_arango/document_collection/mixin'
require 'lucid_arango/document_collection/base'
require 'lucid_arango/edge_collection/mixin'
require 'lucid_arango/edge_collection/base'
require 'lucid_arango/graph/mixin'
require 'lucid_arango/graph/base'
require 'lucid_composable_graph/finders'
require 'lucid_composable_graph/mixin'
require 'lucid_composable_graph/base'
require 'lucid_data/document/mixin'
require 'lucid_data/document/base'
require 'lucid_data/edge/mixin'
require 'lucid_data/edge/base'
require 'lucid_data/collection/finders'
require 'lucid_data/collection/mixin'
require 'lucid_data/collection/base'
require 'lucid_data/graph/finders'
require 'lucid_data/graph/mixin'
require 'lucid_data/graph/base'
require 'lucid_storable_object/mixin'
require 'lucid_storable_object/base'
require 'lucid_remote_object/mixin'
require 'lucid_remote_object/base'

if RUBY_ENGINE == 'opal'
  require 'isomorfeus/data/reducer'
  Isomorfeus::Data::Reducer.add_reducer_to_store
  Isomorfeus.zeitwerk.push_dir('data')
else
  require 'oj'
  require 'active_support'
  require 'active_support/core_ext/hash'
  require 'arango-driver'
  require 'isomorfeus/data/handler/arango'
  require 'isomorfeus/data/handler/generic'
  require 'isomorfeus/data/handler/object_call'
  require 'isomorfeus/data/handler/object_store'

  Opal.append_path(__dir__.untaint) unless Opal.paths.include?(__dir__.untaint)

  path = File.expand_path(File.join('isomorfeus', 'data'))

  Isomorfeus.zeitwerk.push_dir(path)
end
