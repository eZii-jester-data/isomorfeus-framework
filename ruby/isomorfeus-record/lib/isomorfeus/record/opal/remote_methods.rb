module Isomorfeus
  module Record
    module Opal
      module RemoteMethods

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
            @read_states[name] = 'i'
            unless @collection_queries.has_key?(name)
              @collection_queries[name][:result] = Isomorfeus::Record::Collection.new([], self)
              @update_on_link[name] = {}
            end
            raise "#{self.class.to_s}[_no_id_].#{name}, can't execute instance collection_query without id!" unless self.id
            request = { 'isomorfeus/handler/model/read' => { self.class.model_name => { instances: { id => { collection_queries: { name => {}}}}}}}
            Isomorfeus::Transport.promise_send(request).then do
              @collection_query[name][:result]
            end.fail do |response|
              error_message = "#{self.class.to_s}[#{self.id}].#{name}, a collection_query, failed to execute!"
              `console.error(error_message)`
              response
            end
          end
          # @!method [name]
          # @return result either the default_result ass specified in the options or the real result if the RPC call already finished
          define_method(name) do
            unless self.id
              options[:default_result]
            else
              _register_observer
              unless @collection_query.has_key?(name)
                @collection_queries[name][:result] = Isomorfeus::Record::Collection.new([], self)
                @update_on_link[name] = {}
              end
              unless @read_states.has_key?(name) && 'fi'.include?(@read_states[name])
                self.send("promise_#{name}")
              end
            end
            @remote_methods[name][:result]
          end
          # @!method update_[name] mark internal structures so that the method is called again once it is requested again
          # @return nil
          define_method("update_#{name}") do
            @read_states[name] = 'u'
            nil
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
        #   default_result: result to present during render during method call in progress
        #
        # This macro defines additional methods:
        def remote_class_method(name, options = { default_result: '...' })
          remote_class_methods[name] = options
          # @!method promise_[name]
          # @return [Promise] on success the .then block will receive the result of the RPC call as arg
          #    on failure the .fail block will receive some error indicator or nothing
          define_singleton_method("promise_#{name}") do |*args|
            name_args = _name_args(name, *args)
            _class_read_states[name_args] = 'i'
            remote_class_methods[name_args] = { result: options[:default_result] } unless remote_class_methods.has_key?(name_args)
            request = { 'isomorfeus/handler/model/read' => { self.model_name => { remote_methods: { name =>{ args => {}}}}}}
            Isomorfeus::Transport.promise_send(request).then do
              remote_class_methods[name_args][:result]
            end.fail do |response|
              error_message = "#{self.to_s}.#{name}, a remote_method, failed to execute!"
              `console.error(error_message)`
              response
            end
          end
          # @!method [name]
          # @return result either the default_result ass specified in the options or the real result if the RPC call already finished
          define_singleton_method(name) do |*args|
            name_args = _name_args(name, *args)
            _register_class_observer
            remote_class_methods[name_args] = { result: options[:default_result] } unless remote_class_methods.has_key?(name_args)
            unless _class_read_states.has_key?(name_args) && 'fi'.include?(_class_read_states[name_args])
              self.send("promise_#{name}", *args)
            end
            remote_class_methods[name_args][:result]
          end
          # @!method update_[name] mark internal structures so that the method is called again once it is requested again
          # @return nil
          define_singleton_method("update_#{name}") do |*args|
            _class_read_states[_name_args(name, *args)] = 'u'
            nil
          end
        end

        # macro define remote_methods, RPC on instance level of a record of current Isomorfeus::Record class
        #
        # @param name [Symbol] name of method
        # @param options [Hash] with known keys:
        #   default_result: result to present during render during method call in progress
        #
        # This macro defines additional methods:
        def remote_method(name, options = { default_result: '...' })
          # @!method promise_[name]
          # @return [Promise] on success the .then block will receive the result of the RPC call as arg
          #    on failure the .fail block will receive some error indicator or nothing
          define_method("promise_#{name}") do |*args|
            args_json = args.to_json
            @read_states[name] = {} unless @read_states.has_key?(name)
            @read_states[name][args_json] = 'i'
            @remote_methods[name] = {}.merge!(options) unless @remote_methods.has_key?(name)
            @remote_methods[name][args_json] = { result: options[:default_result] } unless @remote_methods[name].has_key?(args_json)
            raise "#{self.class.to_s}[_no_id_].#{name}, can't execute instance remote_method without id!" unless self.id
            request = { 'isomorfeus/handler/model/read' => { self.class.model_name => { instances: { id => { remote_methods: { name => { args => {}}}}}}}}
            Isomorfeus::Transport.promise_send(request).then do
              @remote_methods[name][args_json][:result]
            end.fail do |response|
              error_message = "#{self.class.to_s}[#{self.id}].#{name}, a remote_method, failed to execute!"
              `console.error(error_message)`
              response
            end
          end
          # @!method [name]
          # @return result either the default_result ass specified in the options or the real result if the RPC call already finished
          define_method(name) do |*args|
            unless self.id
              options[:default_result]
            else
              _register_observer
              args_json = args.to_json
              @remote_methods[name] = {}.merge!(options) unless @remote_methods.has_key?(name)
              @remote_methods[name][args_json] = { result: options[:default_result] } unless @remote_methods[name].has_key?(args_json)
              unless @read_states.has_key?(name) && @read_states[name].has_key?(args_json) && 'fi'.include?(@read_states[name][args_json])
                self.send("promise_#{name}", *args)
              end
              @remote_methods[name][args_json][:result]
            end
          end
          # @!method update_[name] mark internal structures so that the method is called again once it is requested again
          # @return nil
          define_method("update_#{name}") do
            @read_states[name] = 'u'
            nil
          end
        end

        # Find a collection of records by example properties.
        #
        # @param property_hash [Hash] properties with values used to identify wanted records
        #
        # @return [Promise] on success the .then block will receive a [Isomorfeus::Record::Collection] as arg
        #     on failure the .fail block will receive some error indicator or nothing
        def promise_where(property_hash)
          request = { 'isomorfeus/handler/model/read' => { self.model_name => { where: property_hash }}}
          Isomorfeus::Transport.promise_send(request).fail do |response|
            error_message = "#{self.to_s}.where(#{property_hash} failed, #{response}!"
            `console.error(error_message)`
            response
          end
        end

      end
    end
  end
end
