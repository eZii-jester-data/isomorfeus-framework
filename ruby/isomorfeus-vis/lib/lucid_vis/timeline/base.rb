module LucidVis
  module Timeline
    class Base
      include Isomorfeus::Vis::Timeline::Mixin
      def self.inherited(base)
        base.class_eval do
          param items: nil
          param groups: nil
          param options: nil
        end
      end
    end
  end
end