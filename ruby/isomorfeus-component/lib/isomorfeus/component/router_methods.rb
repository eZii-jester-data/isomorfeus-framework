module Isomorfeus
  module Component
    module RouterMethods
      def self.included(base)
        base.param :match, default: nil
        base.param :location, default: nil
        base.param :history, default: nil
      end

      def match
        params.match
      end

      def location
        params.location
      end

      def history
        params.history
      end
    end
  end
end
