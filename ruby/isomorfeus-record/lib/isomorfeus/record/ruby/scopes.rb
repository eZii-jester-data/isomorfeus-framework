module Isomorfeus
  module Record
    module Ruby
      module Scopes
        # introspect defined scopes
        # @return [Hash]
        def model_scopes
          @model_scopes ||= {}
        end

        # defines a scope, wrapper around ORM method
        # @param name [Symbol] name of the args
        # @param *args additional args, passed to ORMs scope DSL
        def scope(name, *options)
          model_scopes[name] = options
          singleton_class.send(:define_method, "promise_#{name}") do |*args|
            p = Promise.new(success: proc { send(name, *args) })
            p.resolve
            p
          end
          super(name, *options)
        end
      end
    end
  end
end
