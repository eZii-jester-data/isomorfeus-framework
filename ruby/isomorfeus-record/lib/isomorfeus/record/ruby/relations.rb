module Isomorfeus
  module Record
    module Ruby
      module Relations

        def belongs_to(direction, *args)
          if args[0]
            if args[0].is_a?(Hash)
              relation_name = direction
            elsif args[0].is_a?(Proc)
              relation_name = direction
            end
          elsif args.empty?
            relation_name = direction
          end
          define_method("promise_#{relation_name}") do
            p = Promise.new(success: proc { send(relation_name) })
            p.resolve
            p
          end
          super(direction, *args)
        end

        def has_and_belongs_to_many(direction, *args)
          if args[0]
            if args[0].is_a?(Hash)
              relation_name = direction
            elsif args[0].is_a?(Proc)
              relation_name = direction
            end
          elsif args.empty?
            relation_name = direction
          end
          define_method("promise_#{relation_name}") do
            p = Promise.new(success: proc { send(relation_name) })
            p.resolve
            p
          end
          super(direction, *args)
        end

        def has_many(direction, *args)
          if args[0]
            if args[0].is_a?(Hash)
              relation_name = direction
            elsif args[0].is_a?(Proc)
              relation_name = direction
            end
          elsif args.empty?
            relation_name = direction
          end
          define_method("promise_#{relation_name}") do
            p = Promise.new(success: proc { send(relation_name) })
            p.resolve
            p
          end
          super(direction, *args)
        end

        def has_one(direction, *args)
          if args[0]
            if args[0].is_a?(Hash)
              relation_name = direction
            elsif args[0].is_a?(Proc)
              relation_name = direction
            end
          elsif args.empty?
            relation_name = direction
          end
          define_method("promise_#{relation_name}") do
            p = Promise.new(success: proc { send(relation_name) })
            p.resolve
            p
          end
          super(direction, *args)
        end
      end
    end
  end
end
