module Isomorfeus
  module Record
    class Base
      def self.inherited(base)
        base.include(Isomorfeus::Record::Mixin)
      end
    end
  end
end