module Isomorfeus
  module Model
    module Reducers
      def self.add_record_reducer_to_store
        record_reducer = Redux.create_reducer do |prev_state, action|
          # for better performance this should all be javascript
          action_type = action[:type]
          if action_type.JS.startsWith('RECORD_')
            case action_type
              # structure:
              # records: model_name => instances => id => properties|changed_properties => prop => value
              #                                           collection_queries => query_name => args => value
              #                                           remote_methods => method_name => args => result
              #                                           relations => relation_name => value
              #                                           relation_participation => model_name => id => relation_name
              #                                           edge_participation => type => edge_id
              #                                           scope_participation => model_name => scope_name => scope_args
              #                                           collection_query_participation => model_name => id => query_name
              #                         remote_class_methods => method_name => args => result
              #                         scopes => scope_name => args => value
              #
              # edges: type => id => from/to => [model_name, id]
              #              prop => value
            when 'RECORD_SET_PROPERTY'
              new_state = {}.merge!(prev_state)
              Redux.set_state_path(new_state, :records, action[:model], :instances. action[:id], :changed_properties, action[:object_id], action[:property],
                                   action[:value])
              new_state
            when 'RECORD_SET_PROPERTIES'
              new_state = {}.merge!(prev_state)
              prev_props = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :changed_properties, action[:object_id])
              prev_props = {} unless prev_props
              Redux.set_state_path(new_state, :records, action[:model], :instances, action[:id], :changed_properties, action[:object_id],
                                   prev_props.merge!(action[:properties]))
              new_state
            when 'RECORD_SET_ID'
              new_state = {}.merge!(prev_state)
              Redux.set_state_path(new_state, :records, action[:model], :instances, action[:new_id], new_state[action[:model]][:instances].delete(action[:id]))
              # update relations
              relation_participation = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :relation_participation)
              relation_participation.each do |model_name, _|
                records = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :relation_participation, model_name)
                records.each do |id, _|
                  relations = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :relation_participation, model_name, id)
                  relations.each do |relation_name, _|
                    relation = Redux.get_state_path(new_state, :records, model_name, id, :relations, relation_name)
                    index = relation.index([action[:model], action[:id]])
                    relation[index] = [action[:model], action[:new_id]]
                  end
                end
              end
              # update scopes
              scope_participation = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :scope_participation)
              scope_participation.each do |model_name, _|
                scopes = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :scope_participation, model_name)
                scopes.each do |scope_name, _|
                  scope = Redux.get_state_path(new_state, :records, model_name, :sopes, scope_name)
                  index = relation.index([action[:model], action[:id]])
                  scope[index] = [action[:model], action[:new_id]]
                end
              end
              # update collection_queries
              collection_query_participation = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :collection_query_participation)
              collection_query_participation.each do |model_name, _|
                records = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :collection_query_participation, model_name)
                records.each do |id, _|
                  collection_queries = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :collection_query_participation, model_name, id)
                  collection_queries.each do |relation_name, _|
                    collection_query = Redux.get_state_path(new_state, :records, model_name, id, :collection_queries, relation_name)
                    index = collection_query.index([action[:model], action[:id]])
                    collection_query[index] = [action[:model], action[:new_id]]
                  end
                end
              end
              # update edges
              edge_participation = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :edge_participation)
              edge_participation.each do |type, _|
                edges = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :edge_participation, type)
                edges.each do |id, _|
                  edge = Redux.get_state_path(new_state, :edges, type, id)
                  edge[:from] == [action[:model], action[:new_id]] if edge[:from] == [action[:model], action[:id]]
                  edge[:to] == [action[:model], action[:new_id]] if edge[:to] == [action[:model], action[:id]]
                end
              end
              new_state
            when 'RECORD_SET_RELATION'
              new_state = {}.merge!(prev_state)
              Redux.set_state_path(new_state, :records, action[:model], :instances, action[:id], :relations, action[:relation], action[:value])
              action[:value].each do |record|
                Redux.set_state_path(new_state, :records, record[0], :instances, record[1], :relation_participation, action[:model], action[:id], action[:relation])
              end
              new_state
            when 'RECORD_SET_COLLECTION_QUERY'
              new_state = {}.merge!(prev_state)
              Redux.set_state_path(new_state, action[:model], :instances, action[:id], :collection_queries, action[:query], action[:value])
              action[:value].each do |record|
                Redux.set_state_path(new_state, :records, record[0], :instances, record[1], :collection_query_participation, action[:model], action[:id], action[:query])
              end
              new_state
            when 'RECORD_SET_REMOTE_CLASS_METHOD'
              new_state = {}.merge!(prev_state)
              Redux.set_state_path(new_state, action[:model], :remote_class_method, action[:args], action[:value])
              new_state
            when 'RECORD_SET_REMOTE_METHOD'
              new_state = {}.merge!(prev_state)
              Redux.set_state_path(new_state, action[:model], :instances, action[:id], :remote_methods, action[:args], action[:value])
              new_state
            when 'RECORD_SET_SCOPE'
              new_state = {}.merge!(prev_state)
              Redux.set_state_path(new_state, action[:model], :scopes, action[:args], action[:value])
              action[:value].each do |record|
                Redux.set_state_path(new_state, :records, record[0], :instances, record[1], :scope_participation, action[:model], action[:scope], action[:args])
              end
              new_state
            when 'RECORD_RESET'
              new_state = {}.merge!(prev_state)
              Redux.delete_state_path(new_state, action[:model], :instances, action[:id], :changed_properties, action[:object_id])
              new_state
            when 'RECORD_DESTROY'
              new_state = {}.merge!(prev_state)
              # remove from relations
              relat ion_participation = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :relation_participation)
              relation_participation.each do |model_name, _|
                records = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :relation_participation, model_name)
                records.each do |id, _|
                  relations = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :relation_participation, model_name, id)
                  relations.each do |relation_name, _|
                    relation = Redux.get_state_path(new_state, :records, model_name, id, :relations, relation_name)
                    relation.delete([action[:model], action[:id]])
                  end
                end
              end
              # remove from scopes
              scope_participation = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :scope_participation)
              scope_participation.each do |model_name, _|
                scopes = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :scope_participation, model_name)
                scopes.each do |scope_name, _|
                  scope_args = scopes[scope_name]
                  scope_args.each do |scope_arg, _| 
                    scope = Redux.get_state_path(new_state, :records, model_name, :sopes, scope_name, scope_arg)
                    scope.delete([action[:model], action[:new_id]])
                  end
                end
              end
              # remove from collection_queries
              collection_query_participation = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :collection_query_participation)
              collection_query_participation.each do |model_name, _|
                records = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :collection_query_participation, model_name)
                records.each do |id, _|
                  collection_queries = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :collection_query_participation, model_name, id)
                  collection_queries.each do |relation_name, _|
                    collection_query = Redux.get_state_path(new_state, :records, model_name, id, :collection_queries, relation_name)
                    collection_query.delete([action[:model], action[:new_id]])
                  end
                end
              end
              # update edges
              edge_participation = Redux.get_state_path(new_state, :records action[:model], :instances, action[:id], :edge_participation)
              edge_participation.each do |type, _|
                edges = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :edge_participation, type)
                edges.each do |id, _|
                  edge = Redux.get_state_path(new_state, :edges, type, id)
                  other_record = nil
                  other_record = edge[:to] if edge[:from] == [action[:model], action[:id]]
                  other_record = edge[:from] if edge[:to] == [action[:model], action[:id]]
                  if other_record
                    Redux.delete_state_path(new_state, :edges, type, id)
                    Redux.delete_state_path(new_state, :records, other_record[0], :instances, other_record[1], :edge_participation, type, id)
                  end
                end
              end
              instances = Redux.get_state_path(new_state, :records, action[:model], :instances)
              instances.delete(action[:id]) if instances
              new_state
            when 'RECORD_ADD_TO_RELATION'
              new_state = {}.merge!(prev_state)
              relation = Redux.get_state_path(new_state, :records, action[:model], :instances, action[:id], :relations, action[:relation])
              if relation
                relation << [action[:other_model], action[:other_id]]
              else
                Redux.set_state_path(new_state, :records, action[:model], :instances, action[:id], :relations, action[:relation],
                                     [action[:other_model], action[:other_id]])
              end
              Redux.set_state_path(new_state, :records, action[:other_model], :instances, action[:other_id], :relation_participation, action[:model], action[:id], action[:relation])
              new_state
            when 'RECORD_REMOVE_FROM_RELATION'
              new_state = {}.merge!(prev_state)
              relation = Redux.get_state_path(new_state, action[:model], :instances, action[:id], :relations, action[:relation])
              if relation
                relation.delete([action[:other_model], action[:other_id]])
              end
              Redux.delete_state_path(new_state, :records, action[:other_model], :instances, action[:other_id], :relation_participation, action[:model], action[:id])
              new_state
            when 'RECORD_LINK'
              new_state = {}.merge!(prev_state)
              Redux.set_state_path(new_state, action[:model], :instances, action[:id], :linked, action[:other_model], :instances, action[:other_id], {})
              Redux.set_state_path(new_state, action[:other_model], :instances, action[:other_id], :linked, action[:model], :instances, action[:id], {})
              new_state
            when 'RECORD_UNLINK'
              new_state = {}.merge!(prev_state)
              left_instances = Redux.get_state_path(new_state, action[:model], :instances, action[:id], :linked, action[:other_model], :instances)
              right_instances = Redux.get_state_path(new_state, action[:other_model], :instances, action[:other_id], :linked, action[:model],
                                                     :instances)
              left_instances.delete(action[:other_id]) if left_instances
              right_instances.delete(action[:id]) if right_instances
              new_state

            else
              prev_state
            end
          else
            prev_state
          end
        end

        Redux::Store.add_reducers(record_state: record_reducer)
      end
    end
  end
end
