module Isomorfeus
  class Router
    module Static
      module ClassMethods
        def route(&block)
          prerender_router(&block)
        end
      end

      def self.included(base)
        base.extend(Isomorfeus::Router::ClassMethods)
        base.extend(ClassMethods)

        base.include(Isomorfeus::Router::InstanceMethods)
        base.include(Isomorfeus::Router::ComponentMethods)
      end
    end
  end
end
