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
            Isomorfeus::DataAccess.promise_fetch('isomorfeus/handler/model/read', self.class.model_name, :instances, @id,
                                                 :collection_query, name).then do |response|
              # TODO response
              Isomorfeus.store.dispatch(type: 'RECORD_SET_COLLECTION_QUERY', model: self.class.model_name, id: @id, object_id: object_id,
                                        value: response)
            end
          end
          # @!method [name]
          # @return result either a empty collection or the real result if the RPC call already finished
          define_method(name) do
            Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id, :collection_query, name)
            result = Isomorfeus::DataAccess.local_fetch(:record_state, self.class.model_name, :instances, @id, :collection_query, name)
            return result if result
            send("promise_#{name}")
            Isomorfeus::Record::Collection.new
          end
        end

        # introspect on available remote_class_methods
        # @return [Hash]
        def remote_class_methods
          @remote_class_methods ||= {}
        end

        # macro define remote_class_methods, RPC on class level of current Isomorfeus::Record class
        #
        # @param name [Symbol] name of method
        # @param options [Hash] with known keys:
        #   default_result: result to present during render during method call in progress for the non promise_ version
        #
        # This macro defines additional methods:
        def remote_class_method(name, options = { default_result: '' })
          remote_class_methods[name] = options
          # @!method promise_[name]
          # @return [Promise] on success the .then block will receive the result of the RPC call as arg
          #    on failure the .fail block will receive some error indicator or nothing
          define_singleton_method("promise_#{name}") do |*args|
            Isomorfeus::DataAccess.promise_fetch(:record, model_name, :remote_class_methods, name, args).then do |response|
              # TODO response
              Isomorfeus.store.dispatch(type: 'RECORD_SET_REMOTE_CLASS_METHOD', model: self.class.model_name, id: @id, object_id: object_id,
                                        value: response)
            end
          end
          # @!method [name]
          # @return result either the default_result ass specified in the options or the real result if the RPC call already finished
          define_singleton_method(name) do |*args|
            Isomorfeus::DataAccess.register_used_store_path(:record, model_name, :remote_class_methods, name, args)
            result = Isomorfeus::DataAccess.local_fetch(:record, model_name, :remote_class_methods, name, args)
            return result if result
            send("promise_#{name}", args)
            remote_class_methods[name][:default_result].dup
          end
        end

        # macro define remote_methods, RPC on instance level of a record of current Isomorfeus::Record class
        #
        # @param name [Symbol] name of method
        # @param options [Hash] with known keys:
        #   default_result: result to present during render during method call in progress for the non promise_ version
        #
        # This macro defines additional methods:
        def remote_method(name, options = { default_result: '' })
          # @!method promise_[name]
          # @return [Promise] on success the then block will receive the result of the RPC call as arg
          #    on failure the .fail block will receive some error indicator or nothing
          define_method("promise_#{name}") do |*args|
            Isomorfeus::DataAccess.promise_fetch(:record_state, self.class.model_name, :instances, @id, :remote_methods, name, args)
              .then do |response|
              # TODO response
              Isomorfeus.store.dispatch(type: 'RECORD_SET_REMOTE_METHOD', model: self.class.model_name, id: @id, object_id: object_id, value: response)
            end
          end
          # @!method [name]
          # @return result either the default_result ass specified in the options or the real result if the RPC call already finished
          define_method(name) do |*args|
            Isomorfeus::DataAccess.register_used_store_path(:record, self.class.model_name, :instances, @id, :remote_methods, name, args)
            result = Isomorfeus::DataAccess.local_fetch(:record, self.class.model_name, :instances, @id, :remote_methods, name, args)
            return result if result
            send("promise_#{name}", args)
            options[:default_result]
          end
        end

        # Find a collection of records by example properties.
        #
        # @param property_hash [Hash] properties with values used to identify wanted records
        #
        # @return [Promise] on success the .then block will receive a [Isomorfeus::Record::Collection] as arg
        #     on failure the .fail block will receive some error indicator or nothing
        def promise_where(property_hash)
          Isomorfeus::DataAccess.promise_store(:record, self.class.model_name, :where, property_hash)
        end
      end
    end
  end
end
