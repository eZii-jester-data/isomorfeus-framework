module Isomorfeus
  module Model
    module Reducers
      def self.add_record_reducer_to_store
        record_reducer = Redux.create_reducer do |prev_state, action|
          return prev_state unless action[:type].JS.startWith('RECORD_')
          case action[:type]
          when 'RECORD_SET_PROPERTY'
            new_state = {}.merge!(prev_state)
            Redux.set_state_path(new_state, action[:model], :instances. action[:id], :changed_properties, action[:object_id], action[:property],
                                 action[:value])
            new_state
          when 'RECORD_SET_PROPERTIES'
            new_state = {}.merge!(prev_state)
            Redux.set_state_path(new_state, action[:model], :instances, action[:id], :properties, action[:properties])
            new_state
          when 'RECORD_SET_ID'
            new_state = {}.merge!(prev_state)
            Redux.set_state_path(new_state, action[:model], :instances, action[:id], new_state[action[:model]][:instances].delete(action[:id]))
            new_state
          when 'RECORD_SET_RELATION'
            new_state = {}.merge!(prev_state)
            Redux.set_state_path(new_state, action[:model], :instances, action[:id], :relations, action[:relation], action[:value])
            new_state
          when 'RECORD_SET_COLLECTION_QUERY'
            new_state = {}.merge!(prev_state)
            Redux.set_state_path(new_state, action[:model], :instances, action[:id], :collection_queries, action[:query], action[:value])
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
            new_state
          when 'RECORD_RESET'
            new_state = {}.merge!(prev_state)
            changed_props = Redux.get_state_path(new_state, action[:model], :instances, action[:id], :changed_properties)
            changed_props.delete(action[:object_id]) if changed_props
            new_state
          when 'RECORD_DESTROY'
            new_state = {}.merge!(prev_state)
            instances = Redux.get_state_path(new_state, action[:model], :instances)
            instances.delete(action[:id]) if instances
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
          when 'RECORD_ADD_TO_RELATION'
            new_state = {}.merge!(prev_state)
            relation = Redux.get_state_path(new_state, action[:model], :instances, action[:id], :relations, action[:relation])
            if relation
              relation << { action[:other_model] => action[:other_id] }
            else
              Redux.set_state_path(new_state, action[:model], :instances, action[:id], :relations, action[:relation],
                                   [action[:other_model] => action[:other_id]])
            end
            new_state
          when 'RECORD_REMOVE_FROM_RELATION'
            new_state = {}.merge!(prev_state)
            relation = Redux.get_state_path(new_state, action[:model], :instances, action[:id], :relations, action[:relation])
            if relation
              relation.delete(action[:other_model] => action[:other_id])
            end
            new_state
          when 'INIT'
            {}
          else
            prev_state
          end
        end

        Redux::Store.add_reducers(record_state: record_reducer)
      end
    end
  end
end
