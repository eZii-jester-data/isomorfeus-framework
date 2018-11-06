module Isomorfeus
  module Record
    module Opal
      module ClassMethods
        def isomorfeus_orm_driver
          @orm_driver ||= Isomorfeus::Model::Driver::ActiveRecord.new(self)
        end

        def isomorfeus_orm_driver=(driver)
          @orm_driver = driver.new(self)
        end

        # create a new instance of current Isomorfeus::Record class and save it to the db
        #
        # @param record_hash [Hash] optional data for the record
        # @return [Isomorfeus::Record] the new instance
        def create(record_hash = {})
          record = new(record_hash)
          record.save # registers used store path
        end

        # create a new instance of current Isomorfeus::Record class and save it to the db
        #
        # @param record_hash [Hash] optional data for the record
        # @return [Promise] on success the .then block will receive the new Isomorfeus::Record instance as arg
        #   on failure the .fail block will receive some error indicator or nothing
        def promise_create(record_hash = {})
          record = new(record_hash)
          record.promise_save
        end

        # find a existing instance of current Isomorfeus::Record class
        #
        # @param id [String] id of the record to find
        # @return [Isomorfeus::Record]
        def find(id)
          return nil if !id
          sid = id.to_s
          return nil if sid == ''
          Isomorfeus::DataAccess.register_used_store_path(:record_state, model_name, :instances, sid)
          local_record = Isomorfeus::DataAccess.local_fetch(:record_state, model_name, :instances, sid)
          return self.new(id: sid) if local_record
          promise_find(sid)
          nil
        end

        # find a existing instance of current Isomorfeus::Record class
        #
        # @param id [String] id of the record to find
        # @return [Promise] on success the .then block will receive the new Isomorfeus::Record instance as arg
        #   on failure the .fail block will receive some error indicator or nothing
        def promise_find(id)
          sid = id.to_s
          Isomorfeus::DataAccess.promise_fetch('isomorfeus/handler/model/read', self.model_name, :instances, sid).then do |response|
            Isomorfeus.store.dispatch(type: 'RECORD_SET_PROPERTIES', model: self.class.model_name, id: @id, object_id: object_id, value: response)
          end
        end

        alias _original_method_missing method_missing

        # @!method promise_find_by find a record by attribute
        #
        # @param method_name [String]
        # @return [Promise] on success the .then block will receive a [Isomorfeus::Record] as arg
        #    on failure the .fail block will receive some error indicator or nothing
        def method_missing(method_name, *args, &block)
          if method_name.start_with?('promise_find_by')
            find_method_name = method_name.sub('promise_', '')
            Isomorfeus::DataAccess.promise_fetch('isomorfeus/handler/model/read', model_name, :find_by, find_method_name, args).then do |response|
              # TODO response
              Isomorfeus.store.dispatch(type: 'RECORD_SET_PROPERTIES', model: self.class.model_name, id: @id, object_id: object_id, value: response)
            end
          else
            super
          end
        end

        # get model_name
        # @return [String]
        def model_name
          @model_name ||= self.to_s.underscore
        end

        # declare a property (attribute) for the current Isomorfeus::Record class
        # @param name [String] or [Symbol]
        # @param options [Hash] following keys are known:
        #   default: a default value to present during render if no other value is known
        # TODO  type: type in case no default or other value is known, type.new will be called
        #
        # This macro defines additional methods:
        def property(name, options = {})
          _property_options[name] = options
          # @!method [name] a getter for the property
          define_method(name) do
            Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id, :properties, name)
            Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id, :changed_properties, object_id, name)
            result = Isomorfeus::DataAccess.local_fetch(:record_state, self.class.model_name, :instances, @id, :changed_properties, object_id, name)
            if result == `null`
              result = Isomorfeus::DataAccess.local_fetch(:record_state, self.class.model_name, :instances, @id, :properties, name)
            end
            result
          end
          # @!method [name]= a setter for the property
          # @param value the new value for the property
          define_method("#{name}=") do |value|
            Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id, :properties, name)
            Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id, :changed_properties, object_id, name)
            Isomorfeus.store.dispatch(type: 'RECORD_SET_PROPERTY', model: self.class.model_name, id: @id, object_id: object_id, prop: name, value: value)
          end
        end

        # introspect on current Isomorfeus::Record class
        # @return [Hash]
        def reflections
          @reflections ||= {}
        end

        def respond_to?(method_name, include_private = false)
          method_name.start_with?('promise_find_by') || super
        end

        private
        # internal, should not be used in application code

        # @private
        def _property_options
          @property_options ||= {}
        end
      end
    end
  end
end
