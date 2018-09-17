module IsmoRouter
  module Mixin
    def self.included(base)
      base.include(::IsmoComponent::Mixin)
      base.extend(::Isomorfeus::Router::ClassMethods)
      base.include(::Isomorfeus::Router::InstanceMethods)
      base.include(::Isomorfeus::Router::ComponentMethods)

      base.class_eval do
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

