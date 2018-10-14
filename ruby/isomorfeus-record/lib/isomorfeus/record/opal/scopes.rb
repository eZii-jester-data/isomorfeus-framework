module Isomorfeus
  module Record
    module Opal
      module Scopes
        # DSL macro to declare a scope
        # options are for the server side ORM, on the client side options are ignored
        #
        # @param name [String] or [Symbol] the name of the relation
        # @param options [Hash] further options
        #
        # This macro defines additional methods:
        def scope(name, _options = {})
          # @!method promise_[name]
          # @return [Promise] on success the .then block will receive a [Isomorfeus::Record::Collection] as arg
          #     on failure the .fail block will receive some error indicator or nothing
          define_singleton_method("promise_#{name}") do |*args|
            args_json = args.to_json
            _class_read_states[name] = {} unless _class_read_states.has_key?(name)
            _class_read_states[name][args_json] = 'i'
            request = { 'isomorfeus/handler/model/read' => { self.model_name => { scopes: { name => { args_json => {}}}}}}
            Isomorfeus::Transport.promise_send(request).then do
              scopes[name][args_json]
            end.fail do |response|
              error_message = "#{self.to_s}.#{name}(#{args_json if args.any}), a scope, failed to read records!"
              `console.error(error_message)`
              response
            end
          end
          # @!method [name] get records of the scope
          # @return [Isomorfeus::Record::Collection] either a empty one, if the data has not been readed yet, or the
          #   collection with the real data, if it has been readed already
          define_singleton_method(name) do |*args|
            args_json = args.to_json
            scopes[name] = {} unless scopes.has_key?(name)
            scopes[name][args_json] = Isomorfeus::Record::Collection.new unless scopes.has_key?(name) && scopes[name].has_key?(args_json)
            _register_class_observer
            unless _class_read_states.has_key?(name) && _class_read_states[name].has_key?(args_json) && 'fi'.include?(_class_read_states[name][args_json])
              self.send("promise_#{name}", *args)
            end
            scopes[name][args_json]
          end
          # @!method update_[name] mark internal structures so that the scope data is updated once it is requested again
          # @return nil
          define_singleton_method("update_#{name}") do |*args|
            _class_read_states[name][args.to_json] = 'u'
            nil
          end
        end

        # introspect on available scopes
        # @return [Hash]
        def scopes
          @scopes ||= {}
        end
      end
    end
  end
end