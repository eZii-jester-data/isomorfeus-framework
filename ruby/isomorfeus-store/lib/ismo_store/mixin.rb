module IsmoStore
  module Mixin
    class << self
      def included(base)
        base.include(Isomorfeus::Store::InstanceMethods)
        base.extend(Isomorfeus::Store::ClassMethods)
        base.extend(Isomorfeus::Store::DispatchReceiver)

        base.singleton_class.define_singleton_method(:__state_wrapper) do
          @__state_wrapper ||= Class.new(Isomorfeus::Store::StateWrapper)
        end

        base.singleton_class.define_singleton_method(:state) do |*args, &block|
          __state_wrapper.define_state_methods(base, *args, &block)
        end
      end
    end
  end
end
