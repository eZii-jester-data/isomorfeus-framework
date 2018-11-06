module Isomorfeus
  module Record
    module Opal
      module InstanceMethods
        attr_reader :id
        attr_accessor :is_new

        # initialize a new instance of current Isomorfeus::Record class
        #
        # @param record_hash [Hash] optional, initial values for properties
        def initialize(record_hash = {})
          record_hash = {} if record_hash.nil?
          id = record_hash[:id]
          if id && id != ''
            @id = id.to_s
            record_hash.delete(:id)
          else
            @id = "new_record_#{object_id}"
          end
          Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id)
          Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id, :changed_properties, object_id)
          Isomorfeus.store.dispatch(type: 'RECORD_SET_PROPERTIES', model: self.class.model_name, id: @id, object_id: object_id, value: record_hash)
        end

        ### convenience api

        # Check if record has been changed since last save.
        # @return boolean
        def changed?
          Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id, :changed_properties, object_id)
          Isomorfeus::DataAccess.local_fetch(:record_state, self.class.model_name, :instances, @id, :changed_properties, object_id).any?
        end

        # destroy record, success is assumed
        # @return nil
        def destroy
          Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id)
          promise_destroy
          nil
        end

        # Check if record has been destroyed.
        # @return [Boolean]
        def destroyed?
          Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id)
          !!Isomorfeus::DataAccess.local_fetch(:record_state, self.class.model_name, :instances, @id)
        end

        def id=(new_id)
          old_id = @id
          @id = new_id.to_s
          Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id)
          Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, new_id)
          Isomorfeus.store.dispatch(type: 'RECORD_SET_ID', model: self.class.model_name, id: @id, old_id: old_id)
          @id
        end

        # link the two records using a relation determined by other_record.class, success is assumed
        #
        # @param other_record [Isomorfeus::Record]
        # @return [Isomorfeus::Record] self
        def link(other_record, options)
          Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id)
          Isomorfeus::DataAccess.register_used_store_path(:record_state, other_record.class.model_name, :instances, other_record.id)
          promise_link(other_record, options) # registers used store path
          self
        end

        # method_missing is used for undeclared properties like in ActiveRecord models
        #
        # Two call signatures:
        # 1. the getter:
        # a_model.a_undeclared_property, returns the value of a_undeclared_property
        # 2. the setter:
        # a_model.a_undeclared_property = value, set a_undeclared_property to value, returns value
        def method_missing(method, arg)
          if method.end_with?('=')
            name = method.chop
            Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id, :properties, name)
            Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id, :changed_properties,
                                                            object_id, name)
            Isomorfeus.store.dispatch(type: 'RECORD_SET_PROPERTY', model: self.class.model_name, id: @id, object_id: object_id, prop: name, value: arg)
            arg
          else
            Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id, :properties, method)
            Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id, :changed_properties,
                                                            object_id, method)
            result = Isomorfeus::DataAccess.local_fetch(:record_state, self.class.model_name, :instances, @id, :changed_properties, object_id,
                                                        method)
            if result == `null`
              result = Isomorfeus::DataAccess.local_fetch(:record_state, self.class.model_name, :instances, @id, :properties, method)
            end
            result
          end
        end

        # introspection
        # @return [Hash]
        def reflections
          self.class.reflections
        end

        # reset properties to last saved value
        #
        # @return [Isomorfeus::Record] self
        def reset
          Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id)
          Isomorfeus.store.dispatch(type: 'RECORD_RESET', model: self.class.model_name, id: @id, object_id: object_id)
          self
        end

        # save record to db, success is assumed
        #
        # @return [Isomorfeus::Record] self
        def save
          promise_save
          self
        end

        # return record properties as Hash
        #
        # @return [Hash]
        #
        def to_hash
          Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id)
          changed_properties = Isomorfeus::DataAccess.local_fetch(:record_state, self.class.model_name, :instances, @id, :changed_properties,
                                                                  object_id)
          properties = Isomorfeus::DataAccess.local_fetch(:record_state, self.class.model_name, :instances, @id, :properties)
          properties.merge(changed_properties) if changed_properties
          properties
        end

        # return record properties as String
        #
        # @return [String]
        def to_s
          to_hash.to_s
        end

        # return record properties as hash, ready for transport
        #
        # @return [Hash]
        def to_transport_hash
          id_key = @id ? @id : "_new_#{`Date.now() + Math.random()`}"
          { self.class.model_name => { id_key => { properties: to_hash }}}
        end

        # unlink the two records using a relation determined by other_record.class, success is assumed
        #
        # @return [Isomorfeus::Record] self
        def unlink(other_record, options)
          Isomorfeus::DataAccess.register_used_store_path(:record_state, self.class.model_name, :instances, @id)
          Isomorfeus::DataAccess.register_used_store_path(:record_state, other_record.class.model_name, :instances, other_record.id)
          promise_unlink(other_record, options)
          self
        end

        ### promise api

        # destroy record
        #
        # @return [Promise] on success the record is passed to the .then block
        #   on failure the .fail block will receive some error indicator or nothing
        def promise_destroy
          Isomorfeus.store.dispatch(type: 'RECORD_DESTROY', model: self.class.model_name, id: @id)
          if @id
            Isomorfeus::DataAccess.promise_fetch('isomorfeus/handler/model/destroy', self.class.model_name, :instances, @id, :destroy)
          else
            Promise.new.resolve(self)
          end
        end

        # link the two records using a relation determined by other_record.class
        #
        # @param other_record [Isomorfeus::Record]
        # @return [Promise] on success the record is passed to the .then block
        #   on failure the .fail block will receive some error indicator or nothing
        def promise_link(other_record, options)
          raise 'Direct Record linking not supported in Model Driver!' if self.class.isomorfeus_orm_driver.linking_requires_relation?
          Isomorfeus.store.dispatch(type: 'RECORD_LINK', model: self.class.model_name, id: @id, other_model: other_record.class.model_name,
                                    other_id: other_record.id, options: options)
          Isomorfeus::DataAccess.promise_store('isomorfeus/handler/model/link', self.class.model_name, @id, :link, other_record.class.model_name, other_record.id,
                                       :options, options).then do
            self
          end
        end

        # save record
        #
        # @return [Promise] on success the record is passed to the .then block
        #   on failure the .fail block will receive some error indicator or nothing
        def promise_save
          changed_properties = Isomorfeus::DataAccess.local_fetch(:record_state, self.class.model_name, :instances, @id, :changed_properties)
          properties = Isomorfeus::DataAccess.local_fetch(:record_state, self.class.model_name, :instances, @id, :properties)
          Isomorfeus.store.dispatch(type: 'RECORD_SAVE', model: self.class.model_name, id: @id)
          handler = @id.start_with?('new_record_') ? 'isomorfeus/handler/model/create' : 'isomorfeus/handler/model/update'
          Isomorfeus::DataAccess.promise_store(handler, self.class.model_name, :instances, @id, :properties,
                                               properties.merge(changed_properties)).then do
            self
          end
        end

        # unlink the two records using a relation determined by other_record.class
        #
        # @param other_record [Isomorfeus::Record]
        # @return [Promise] on success the record is passed to the .then block
        #   on failure the .fail block will receive some error indicator or nothing
        def promise_unlink(other_record, options)
          raise 'Direct Record unlinking not supported in Model Driver!' if self.class.isomorfeus_orm_driver.linking_requires_relation?
          Isomorfeus.store.dispatch(type: 'RECORD_UNLINK', model: self.class.model_name, id: @id, other_model: other_record.class.model_name,
                                    other_id: other_record.id, options: options)
          Isomorfeus::DataAccess.promise_store('isomorfeus/handler/model/unlink', self.class.model_name, @id, :unlink, other_record.class.model_name, other_record.id,
                                       :options, options).then do
            self
          end
        end
      end
    end
  end
end