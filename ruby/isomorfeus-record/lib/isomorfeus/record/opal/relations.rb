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
            _register_observer
            @read_states[relation_name] = 'i'
            request = { 'isomorfeus/handler/model/read' => { self.class.model_name => { instances: { id => { relations: { relation_name => {}}}}}}}
            Isomorfeus::Transport.promise_send(request).then do
              self
            end.fail do |response|
              error_message = "#{self.class.to_s}[#{self.id}].#{relation_name}, a belongs_to association, failed to read records!"
              `console.error(error_message)`
              response
            end
          end
          # @!method [relation_name] get records of the relation
          # @return [Isomorfeus::Record::Collection] either a empty one, if the data has not been readed yet, or the
          #   collection with the real data, if it has been readed already
          define_method(relation_name) do
            if @read_states[relation_name] == 'i'
              _register_observer
            elsif self.id && @read_states[relation_name] != 'f'
              send("promise_#{relation_name}")
            end
            @relations[relation_name]
          end
          # @!method update_[relation_name] mark internal structures so that the relation data is updated once it is requested again
          # @return nil
          define_method("update_#{relation_name}") do
            @read_states[relation_name] = 'u'
            nil
          end
          # TODO, needs the network part, post to server
          # define_method("#{name}=") do |arg|
          #   _register_observer
          #   @relations[name] = arg
          #   @read_states[name] = 'f'
          #   @relations[name]
          # end
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
            _register_observer
            @read_states[relation_name] = 'i'
            request = { 'isomorfeus/handler/model/read' => { self.class.model_name => { instances: { id => { relations: { relation_name => {}}}}}}}
            Isomorfeus::Transport.promise_send(request).then do
              self
            end.fail do |response|
              error_message = "#{self.class.to_s}[#{self.id}].#{relation_name}, a has_and_belongs_to_many association, failed to read records!"
              `console.error(error_message)`
              response
            end
          end
          # @!method [relation_name] get records of the relation
          # @return [Isomorfeus::Record::Collection] either a empty one, if the data has not been readed yet, or the
          #   collection with the real data, if it has been readed already
          define_method(relation_name) do
            if @read_states[relation_name] == 'i'
              _register_observer
            elsif self.id && @read_states[relation_name] != 'f'
              send("promise_#{relation_name}")
            end
            @relations[relation_name]
          end
          # @!method update_[relation_name] mark internal structures so that the relation data is updated once it is requested again
          # @return nil
          define_method("update_#{relation_name}") do
            @read_states[relation_name] = 'u'
            nil
          end
          # TODO
          # define_method("#{name}=") do |arg|
          #   _register_observer
          #   collection = if arg.is_a?(Array)
          #                  Isomorfeus::Record::Collection.new(arg, self, name)
          #                elsif arg.is_a?(Isomorfeus::Record::Collection)
          #                  arg
          #                else
          #                  raise "Argument must be a Isomorfeus::Record::Collection or a Array"
          #                end
          #   @relations[name] = collection
          #   @read_states[name] = 'f'
          #   @relations[name]
          # end
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
            _register_observer
            @read_states[relation_name] = 'i'
            request = { 'isomorfeus/handler/model/read' => { self.class.model_name => { instances: { id => { relations: { relation_name => {}}}}}}}
            Isomorfeus::Transport.promise_send(request).then do
              self
            end.fail do |response|
              error_message = "#{self.class.to_s}[#{self.id}].#{relation_name}, a has_many association, failed to read records!"
              `console.error(error_message)`
              response
            end
          end
          # @!method [relation_name] get records of the relation
          # @return [Isomorfeus::Record::Collection] either a empty one, if the data has not been readed yet, or the
          #   collection with the real data, if it has been readed already
          define_method(relation_name) do
            if @read_states[relation_name] == 'i'
              _register_observer
            elsif self.id && @read_states[relation_name] != 'f'
              send("promise_#{relation_name}")
            end
            @relations[relation_name]
          end
          # @!method update_[relation_name] mark internal structures so that the relation data is updated once it is requested again
          # @return nil
          define_method("update_#{relation_name}") do
            @read_states[relation_name] = 'u'
            nil
          end
          # define_method("#{relation_name}=") do |arg|
          #   _register_observer
          #   collection = if arg.is_a?(Array)
          #     Isomorfeus::Record::Collection.new(arg, self, relation_name)
          #   elsif arg.is_a?(Isomorfeus::Record::Collection)
          #     arg
          #   else
          #     raise "Argument must be a Isomorfeus::Record::Collection or a Array"
          #   end
          #   @relations[relation_name] = collection
          #   @read_states[relation_name] = 'f'
          #   @relations[relation_name]
          # end
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
            @read_states[relation_name] = 'i'
            request = { 'isomorfeus/handler/model/read' => { self.class.model_name => { instances: { id => { relations: { relation_name => {}}}}}}}
            Isomorfeus::Transport.promise_send(request).then do
              self
            end.fail do |response|
              error_message = "#{self.class.to_s}[#{self.id}].#{relation_name}, a has_one association, failed to read records!"
              `console.error(error_message)`
              response
            end
          end
          # @!method [relation_name] get records of the relation
          # @return [Isomorfeus::Record::Collection] either a empty one, if the data has not been readed yet, or the
          #   collection with the real data, if it has been readed already
          define_method(relation_name) do
            if @read_states[relation_name] == 'i'
              _register_observer
            elsif self.id && @read_states[relation_name] != 'f'
              send("promise_#{relation_name}")
            end
            @relations[relation_name]
          end
          # @!method update_[relation_name] mark internal structures so that the relation data is updated once it is requested again
          # @return nil
          define_method("update_#{relation_name}") do
            @read_states[relation_name] = 'u'
            nil
          end
          # define_method("#{relation_name}=") do |arg|
          #   _register_observer
          #   @relations[relation_name] = arg
          #   @read_states[relation_name] = 'f'
          #   @relations[relation_name]
          # end
        end
      end
    end
  end
end
