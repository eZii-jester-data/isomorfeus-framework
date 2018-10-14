module LucidVis
  module Network
    class Base
      include Isomorfeus::Vis::Network::Mixin
      def self.inherited(base)
        base.class_eval do
          param vis_data: nil
          param options: nil
        end
      end
    end
  end
end