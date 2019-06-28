module Isomorfeus
  module Record
    module Opal
      module RemoteMethods

        # introspect on available collection_queryies
        # @return [Hash]
        def collection_queries
          @_collection_queries ||= {}
        end

        # macro define collection_query, RPC on instance level of a record of current Isomorfeus::Record class
        # The supplied block must return a Array of Records!
        #
        # @param name [Symbol] name of method
        #
        # This macro defines additional methods:
        def collection_query(name)
          # @!method promise_[name]
          # @return [Promise] on success the .then block will receive the result of the RPC call as arg
          #    on failure the .fail block will receive some error indicator or nothing
          collection_queries[name] = {}
          define_method("promise_#{name}") do
            Isomorfeus::Transport.promise_send_path('isomorfeus/handler/model/read', @singular_model_name, :instances, @id,
                                                 :collection_query, name) do |response|
              Isomorfeus.store.dispatch(type: 'RECORD_SET_COLLECTION_QUERY', model: @singular_model_name, id: @id,
                                        collection: response[:agent_response][@singular_model_name][:instances][@id][:collection_queries][name],
                                        records: response[:records])
              reference_array = Redux.fetch_by_path(:record_state, :records, @singular_model_name, :instances, @id, :collection_query, name)
              Isomorfeus::Record::Collection.new(reference_array)
            end
          end
          # @!method [name]
          # @return result either a empty collection or the real result if the RPC call already finished
          define_method(name) do
            Redux.register_used_store_path(:record_state, :records, @singular_model_name, :instances, @id, :collection_query, name)
            result = Redux.fetch_by_path(:record_state, :records, @singular_model_name, :instances, @id, :collection_query, name)
            if result
              result
            else
              send("promise_#{name}")
              Isomorfeus::Record::Collection.new
            end
          end
        end

        # introspect on available remote_class_methods
        # @return [Hash]
        def remote_class_methods
          @_remote_class_methods ||= {}
        end

        # macro define remote_class_methods, RPC on class level of current Isomorfeus::Record class
        #
        # @param name [Symbol] name of method
        # @param options [Hash] with known keys:
        #   default_result: result to present during render during method call in progress for the non promise_ version
        #
        # This macro defines additional methods:
        def remote_class_method(name, options = { default_result: nil })
          remote_class_methods[name] = options
          # @!method promise_[name]
          # @return [Promise] on success the .then block will receive the result of the RPC call as arg
          #    on failure the .fail block will receive some error indicator or nothing
          define_singleton_method("promise_#{name}") do |*args|
            Isomorfeus::Transport.promise_send_path('isomorfeus/handler/model/read', singular_model_name,
                                                    :remote_class_methods, name, args) do |response|
              result = response[:agent_response][singular_model_name][:remote_class_methods][name][args]
              Isomorfeus.store.dispatch(type: 'RECORD_SET_REMOTE_CLASS_METHOD', model: singular_model_name, method: name, value: result)
              result
            end
          end
          # @!method [name]
          # @return result either the default_result ass specified in the options or the real result if the RPC call already finished
          define_singleton_method(name) do |*args|
            Redux.register_used_store_path(:record, model_name, :remote_class_methods, name, args)
            result = Redux.fetch_by_path(:record, model_name, :remote_class_methods, name, args)
            if result
              result
            else
              send("promise_#{name}", args)
              remote_class_methods[name][:default_result].dup
            end
          end
        end

        # macro define remote_methods, RPC on instance level of a record of current Isomorfeus::Record class
        #
        # @param name [Symbol] name of method
        # @param options [Hash] with known keys:
        #   default_result: result to present during render during method call in progress for the non promise_ version
        #
        # This macro defines additional methods:
        def remote_method(name, options = { default_result: nil })
          # @!method promise_[name]
          # @return [Promise] on success the then block will receive the result of the RPC call as arg
          #    on failure the .fail block will receive some error indicator or nothing
          define_method("promise_#{name}") do |*args|
            Isomorfeus::Transport.promise_send_path('isomorfeus/handler/model/read', @singular_model_name, :instances, @id,
                                                    :remote_methods, name, args) do |response|
              result = response[:agent_response][singular_model_name][:instances][@id][:remote_methods][name][args]
              Isomorfeus.store.dispatch(type: 'RECORD_SET_REMOTE_METHOD', model: @singular_model_name, id: @id, method: name, value: result)
              result
            end
          end
          # @!method [name]
          # @return result either the default_result ass specified in the options or the real result if the RPC call already finished
          define_method(name) do |*args|
            Redux.register_used_store_path(:record, @singular_model_name, :instances, @id, :remote_methods, name, args)
            result = Redux.fetch_by_path(:record, @singular_model_name, :instances, @id, :remote_methods, name, args)
            if result
              result
            else
              send("promise_#{name}", args)
              options[:default_result].dup
            end
          end
        end
      end
    end
  end
end
