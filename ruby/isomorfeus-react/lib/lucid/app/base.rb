module Lucid
  module App
    class Base
      def self.inherited(base)
        base.include(::Lucid::App::Mixin)
      end
    end
  end
end
