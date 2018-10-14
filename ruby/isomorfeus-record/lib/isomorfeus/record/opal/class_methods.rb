module Isomorfeus
  module Record
    module Opal
      module ClassMethods

        # create a new instance of current Isomorfeus::Record class or return a existing one if a id in the hash is given
        #
        # @param record_hash [Hash] optional data for the record
        # @return [Isomorfeus::Record] the new instance or the existing one for a given id
        def new(record_hash = {})
          if record_hash.has_key?(:id)
            sid = record_hash[:id].to_s
            if _record_cache.has_key?(sid)
              record = _record_cache[sid]
              if record
                record._initialize_from_hash(record_hash)
                record._register_observer
                return record
              end
            end
          end
          super(record_hash)
        end

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
          record.save
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
          return nil if !id || id.respond_to?(:is_dummy?)
          sid = id.to_s
          return nil if sid == ''
          record_sid = "record_#{sid}"
          if _record_cache.has_key?(sid) && _class_read_states.has_key?(record_sid)
            _register_class_observer if _class_read_states[record_sid] == 'i'
            return _record_cache[sid] if 'fi'.include?(_class_read_states[record_sid])
          end
          record_in_progress = if _record_cache.has_key?(sid)
                                 _record_cache[sid]
                               else
                                 self.new(id: sid)
                               end
          promise_find(sid)
          record_in_progress
        end

        # find a existing instance of current Isomorfeus::Record class
        #
        # @param id [String] id of the record to find
        # @return [Promise] on success the .then block will receive the new Isomorfeus::Record instance as arg
        #   on failure the .fail block will receive some error indicator or nothing
        def promise_find(id)
          sid = id.to_s
          record_sid = "record_#{sid}"
          _class_read_states[record_sid] = 'i'
          request = { 'isomorfeus/handler/model/read' => { self.model_name => { instances: { sid => {}}}}}
          _register_class_observer
          Isomorfeus::Transport.promise_send(request).then do
            notify_class_observers
            _record_cache[sid]
          end.fail do |response|
            error_message = "#{self.to_s}.find(#{sid}) failed to read record!"
            `console.error(error_message)`
            response
          end
        end

        alias _original_method_missing method_missing

        # @!method promise_find_by find a record by attribute
        #
        # @param property_hash [Hash]
        #
        # @return [Promise] on success the .then block will receive a [Isomorfeus::Record] as arg
        #    on failure the .fail block will receive some error indicator or nothing
        def method_missing(method_name, *args, &block)
          if method_name.start_with?('promise_find_by')
            handler_method_name = method_name.sub('promise_', '')
            request = { 'isomorfeus/handler/model/read' => { self.model_name => { find_by: { handler_method_name => args }}}}
            Isomorfeus::Transport.promise_send(request).fail do |response|
              error_message = "#{self.to_s}.#{method_name}(#{args}) failed, #{response}!"
              `console.error(error_message)`
              response
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

        # notify class observers, will change state of observers
        # @return nil
        def notify_class_observers
          _class_observers.each do |observer|
            React::State.set_state(observer, _class_state_key, `Date.now() + Math.random()`)
          end
          _class_observers = Set.new
          nil
        end

        # declare a property (attribute) for the current Isomorfeus::Record class
        # @param name [String] or [Symbol]
        # @param options [Hash] following keys are known:
        #   default: a default value to present during render if no other value is known
        #   type: type for a Isomorfeus::Record::DummyValue in case no default or other value is known
        #
        # This macro defines additional methods:
        def property(name, options = {})
          _property_options[name] = options
          # @!method [name] a getter for the property
          define_method(name) do
            _register_observer
            if @properties[:id]
              if @changed_properties.has_key?(name)
                @changed_properties[name]
              else
                @properties[name]
              end
            else
              # record has not been readed or is new and not yet saved
              if @properties[name].nil?
                # TODO move default to initializer?
                if self.class._property_options[name].has_key?(:default)
                  self.class._property_options[name][:default]
                elsif self.class._property_options[name].has_key?(:type)
                  self.class._property_options[name][:type].new
                else
                  nil
                end
              else
                @properties[name]
              end
            end
          end
          # @!method [name]= a setter for the property
          # @param value the new value for the property
          define_method("#{name}=") do |value|
            _register_observer
            @changed_properties[name] = value
          end
        end

        # check if a record of current Isomorfeus::Record class has been cached already
        # @param id [String]
        def record_cached?(id)
          _record_cache.has_key?(id.to_s)
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
        def _class_read_states
          @_class_read_states ||= { all: { '[]' => 'n' }} # all is treated as scope
          @_class_read_states
        end

        # @private
        def _class_observers
          @_class_observers ||= Set.new
          @_class_observers
        end

        # @private
        def _class_state_key
          @_class_state_key ||= self.to_s
          @_class_state_key
        end

        # @private
        def _name_args(name, *args)
          if args.size > 0
            "#{name}_#{args.to_json}"
          else
            name
          end
        end

        # @private
        def _property_options
          @property_options ||= {}
        end

        # @private
        def _record_cache
          @record_cache ||= {}
        end

        # @private
        def _register_class_observer
          observer = React::State.current_observer
          if observer
            React::State.get_state(observer, _class_state_key)
            _class_observers << observer # @observers is a set, observers get added only once
          end
        end
      end
    end
  end
end
