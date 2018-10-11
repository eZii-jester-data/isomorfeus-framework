module Lucid
  module Component
    class Base
      def self.inherited(base)
        base.include(::Lucid::Component::Mixin)
      end
    end
  end
end
