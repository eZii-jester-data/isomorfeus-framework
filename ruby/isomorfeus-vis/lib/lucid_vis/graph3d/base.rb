module LucidVis
  module Graph3d
    class Base
      include LucidVis::Graph3d::Mixin
      def self.inherited(base)
        base.class_eval do
          param vis_data: nil
          param options: nil
        end
      end
    end
  end
end
