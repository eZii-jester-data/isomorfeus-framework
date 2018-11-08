module Isomorfeus
  module Record
    module Opal
      module Relations
        # DSL macro to declare a belongs_to relationship
        # options are for the server side ORM, on the client side options are ignored
        #
        # This macro defines additional methods:
        # promise_[relation_name]
        #    return [Promise] on success the .then block will receive a [Isomorfeus::Record::Collection] as arg
        #      on failure the .fail block will receive some error indicator or nothing
        #
        # @param direction [String, Symbol] for ORMs like Neo4j: the direction of the graph edge, for ORMs like ActiveRecord: the name of the relation
        # @param relation_name [String, Symbol, Hash] for ORMs like Neo4j: the name of the relation, for ORMs like ActiveRecord: further options
        # @param options [Hash] further options for ORMs like Neo4j
        def belongs_to(direction, relation_name = nil, options = { type: nil })
          if relation_name.is_a?(Hash)
            options.merge(relation_name)
            relation_name = direction
            direction = nil
          elsif relation_name.is_a?(Proc)
            relation_name = direction
            direction = nil
          elsif relation_name.nil?
            relation_name = direction
          end
          reflections[relation_name] = { direction: direction, type: options[:type], kind: :belongs_to }

          define_method("promise_#{relation_name}") do
            Isomorfeus::DataAccess.promise_fetch('isomorfeus/handler/model/read', self.class.model_name, :instances, @id,
                                                 :relations, relation_name)
          end
          # @!method [relation_name] get records of the relation
          # @return [Isomorfeus::Record::Collection] either a empty one, if the data has not been readed yet, or the
          #   collection with the real data, if it has been readed already
          define_method(relation_name) do
            Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id, :relations, relation_name)
            result = Isomorfeus::DataAccess.local_fetch(:record_state, self.class.model_name, :instances, @id, :relations, relation_name)
            return result if result
            send("promise_#{relation_name}")
            nil
          end
          define_method("promise_#{name}=") do |arg|
            Isomorfeus::DataAccess.promise_store(:record_state, self.class.model_name, :instance, @id, :relation, relation_name, arg)
          end
          define_method("#{name}=") do |arg|
            Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id, :relations, relation_name)
            Isomorfeus::DataAccess.promise_store(:record_state, self.class.model_name, :instance, @id, :relation, relation_name, arg)
            arg
          end
        end

        # DSL macro to declare a has_and_belongs_many relationship
        # options are for the server side ORM, on the client side options are ignored
        #
        # @param direction [String] or [Symbol] for ORMs like Neo4j: the direction of the graph edge, for ORMs like ActiveRecord: the name of the relation
        # @param relation_name [String] or [Symbol] or [Hash] for ORMs like Neo4j: the name of the relation, for ORMs like ActiveRecord: further options
        # @param options [Hash] further options for ORMs like Neo4j
        #
        # This macro defines additional methods:
        def has_and_belongs_to_many(direction, relation_name = nil, options = { type: nil })
          if relation_name.is_a?(Hash)
            options.merge(relation_name)
            relation_name = direction
            direction = nil
          elsif relation_name.is_a?(Proc)
            relation_name = direction
            direction = nil
          elsif relation_name.nil?
            relation_name = direction
          end
          reflections[relation_name] = { direction: direction, type: options[:type], kind: :has_and_belongs_to_many }
          # @!method promise_[relation_name]
          # @return [Promise] on success the .then block will receive a [Isomorfeus::Record::Collection] as arg
          #    on failure the .fail block will receive some error indicator or nothing
          define_method("promise_#{relation_name}") do
            Isomorfeus::DataAccess.promise_fetch(:record, self.class.model_name, :instances, @id, :relations, relation_name).then do |response|
              # TODO response
              Isomorfeus.store.dispatch(type: 'RECORD_SET_RELATION', model: self.class.model_name, id: @id, object_id: object_id, value: response)
            end
          end
          # @!method [relation_name] get records of the relation
          # @return [Isomorfeus::Record::Collection] either a empty one, if the data has not been readed yet, or the
          #   collection with the real data, if it has been readed already
          define_method(relation_name) do
            Isomorfeus::DataAccess.register_used_store_path(:record, self.class.model_name, :instances, @id, :relations, relation_name)
            result = Isomorfeus::DataAccess.local_fetch(:record, self.class.model_name, :instances, @id, :relations, relation_name)
            return result if result
            send("promise_#{relation_name}")
            Isomorfeus::Record::Collection.new([], self, relation_name)
          end
          define_method("promise_#{relation_name}=") do |arg|
            Isomorfeus.store.dispatch(type: 'RECORD_SET_RELATION', model: self.class.model_name, id: @id, object_id: object_id, value: arg)
            Isomorfeus::DataAccess.promise_store(:record, self.class.model_name, :instance, @id, :relation, relation_name, arg)
          end
          define_method("#{relation_name}=") do |arg|
            Isomorfeus::DataAccess.register_used_store_path(:record, self.class.model_name, :instances, @id, :relations, relation_name)
            send("promise_#{relation_name}=", arg)
            nil
          end
        end

        # DSL macro to declare a has_many relationship
        # options are for the server side ORM, on the client side options are ignored
        #
        # @param direction [String] or [Symbol] for ORMs like Neo4j: the direction of the graph edge, for ORMs like ActiveRecord: the name of the relation
        # @param relation_name [String] or [Symbol] or [Hash] for ORMs like Neo4j: the name of the relation, for ORMs like ActiveRecord: further options
        # @param options [Hash] further options for ORMs like Neo4j
        #
        # This macro defines additional methods:
        def has_many(direction, relation_name = nil, options = { type: nil })
          if relation_name.is_a?(Hash)
            options.merge(relation_name)
            relation_name = direction
            direction = nil
          elsif relation_name.is_a?(Proc)
            relation_name = direction
            direction = nil
          elsif relation_name.nil?
            relation_name = direction
          end
          reflections[relation_name] = { direction: direction, type: options[:type], kind: :has_many }
          # @!method promise_[relation_name]
          # @return [Promise] on success the .then block will receive a [Isomorfeus::Record::Collection] as arg
          #    on failure the .fail block will receive some error indicator or nothing
          define_method("promise_#{relation_name}") do
            Isomorfeus::DataAccess.promise_fetch(:record, self.class.model_name, :instances, @id, :relations, relation_name).then do |response|
              # TODO response
              Isomorfeus.store.dispatch(type: 'RECORD_SET_RELATION', model: self.class.model_name, id: @id, object_id: object_id, value: response)
            end
          end
          # @!method [relation_name] get records of the relation
          # @return [Isomorfeus::Record::Collection] either a empty one, if the data has not been readed yet, or the
          #   collection with the real data, if it has been readed already
          define_method(relation_name) do
            Isomorfeus::DataAccess.register_used_store_path(:record, self.class.model_name, :instances, @id, :relations, relation_name)
            result = Isomorfeus::DataAccess.local_fetch(:record, self.class.model_name, :instances, @id, :relations, relation_name)
            return result if result
            send("promise_#{relation_name}")
            Isomorfeus::Record::Collection.new([], self, relation_name)
          end
          define_method("promise_#{relation_name}=") do |arg|
            Isomorfeus.store.dispatch(type: 'RECORD_SET_RELATION', model: self.class.model_name, id: @id, object_id: object_id, value: arg)
            Isomorfeus::DataAccess.promise_store(:record, self.class.model_name, :instance, @id, :relation, relation_name, arg)
          end
          define_method("#{relation_name}=") do |arg|
            Isomorfeus::DataAccess.register_used_store_path(:record, self.class.model_name, :instances, @id, :relations, relation_name)
            send("promise_#{relation_name}=", arg)
            nil
          end
        end

        # DSL macro to declare a has_one relationship
        # options are for the server side ORM, on the client side options are ignored
        #
        # @param direction [String] or [Symbol] for ORMs like Neo4j: the direction of the graph edge, for ORMs like ActiveRecord: the name of the relation
        # @param relation_name [String] or [Symbol] or [Hash] for ORMs like Neo4j: the name of the relation, for ORMs like ActiveRecord: further options
        # @param options [Hash] further options for ORMs like Neo4j
        #
        # This macro defines additional methods:
        def has_one(direction, relation_name = nil, options = { type: nil })
          if relation_name.is_a?(Hash)
            options.merge(relation_name)
            relation_name = direction
            direction = nil
          elsif relation_name.is_a?(Proc)
            relation_name = direction
            direction = nil
          elsif relation_name.nil?
            relation_name = direction
          end
          reflections[relation_name] = { direction: direction, type: options[:type], kind: :has_one }
          # @!method promise_[relation_name]
          # @return [Promise] on success the .then block will receive a [Isomorfeus::Record::Collection] as arg
          #    on failure the .fail block will receive some error indicator or nothing
          define_method("promise_#{relation_name}") do
            Isomorfeus::DataAccess.promise_fetch(:record, self.class.model_name, :instances, @id, :relations, relation_name).then do |response|
              # TODO response
              Isomorfeus.store.dispatch(type: 'RECORD_SET_RELATION', model: self.class.model_name, id: @id, object_id: object_id, value: response)
            end
          end
          # @!method [relation_name] get records of the relation
          # @return [Isomorfeus::Record::Collection] either a empty one, if the data has not been readed yet, or the
          #   collection with the real data, if it has been readed already
          define_method(relation_name) do
            Isomorfeus::DataAccess.register_used_store_path(:record, self.class.model_name, :instances, @id, :relations, relation_name)
            result = Isomorfeus::DataAccess.local_fetch(:record, self.class.model_name, :instances, @id, :relations, relation_name)
            return result if result
            send("promise_#{relation_name}")
            nil
          end
          define_method("promise_#{relation_name}=") do |arg|
            Isomorfeus.store.dispatch(type: 'RECORD_SET_RELATION', model: self.class.model_name, id: @id, object_id: object_id, value: arg)
            Isomorfeus::DataAccess.promise_store(:record, self.class.model_name, :instance, @id, :relation, relation_name, arg)
          end
          define_method("#{relation_name}=") do |arg|
            Isomorfeus::DataAccess.register_used_store_path(:record, self.class.model_name, :instances, @id, :relations, relation_name)
            send("promise_#{relation_name}=", arg)
            nil
          end
        end
      end
    end
  end
end
