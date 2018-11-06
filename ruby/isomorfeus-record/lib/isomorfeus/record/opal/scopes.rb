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
            Isomorfeus::DataAccess.promise_fetch(:record, self.model_name, :scope, name, args).then do |response|
              # TODO response
              Isomorfeus.store.dispatch(type: 'RECORD_SET_SCOPE', model: self.class.model_name, id: @id, object_id: object_id, value: response)
            end
          end
          # @!method [name] get records of the scope
          # @return [Isomorfeus::Record::Collection] either a empty one, if the data has not been readed yet, or the
          #   collection with the real data, if it has been readed already
          define_singleton_method(name) do |*args|
            Isomorfeus::DataAccess.register_used_store_path(:record, self.model_name, :scope, name, args)
            result = Isomorfeus::DataAccess.local_fetch(:record, self.model_name, :scope, name, args)
            return result if result
            send("promise_#{name}", args)
            Isomorfeus::Record::Collection.new
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