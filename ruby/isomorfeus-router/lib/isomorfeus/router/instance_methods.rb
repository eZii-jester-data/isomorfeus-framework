module Isomorfeus
  module Router
    module InstanceMethods
      def history
        self.class.history
      end

      def location
        self.class.location
      end
    end
  end
end
