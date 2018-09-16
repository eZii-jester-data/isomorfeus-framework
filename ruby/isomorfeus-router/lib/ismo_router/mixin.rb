module IsmoRouter
  module Mixin
    class << self
      def included(base)
        base.include(::IsmoComponent::Mixin)
        
        base.extend(::Isomorfeus::Router::ClassMethods)
        base.include(::Isomorfeus::Router::InstanceMethods)
        base.include(::Isomorfeus::Router::ComponentMethods)

        base.class_eval do
          param :match, default: nil
          param :location, default: nil
          param :history, default: nil

          define_method(:match) do
            params.match
          end

          define_method(:location) do
            params.location
          end

          define_method(:history) do
            params.history
          end

          after_mount do
            @_react_router_unlisten = history.listen do |location, _action|
              React::State.set_state(Isomorfeus::Router, :location, location)
            end
          end

          before_unmount do
            @_react_router_unlisten.call if @_react_router_unlisten
          end
        end
      end
    end
  end
end

