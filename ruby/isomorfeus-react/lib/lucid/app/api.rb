module Lucid
  module App
    module API
      def self.included(base)
        base.instance_exec do
          def render(&block)
            define_method :instance_render do
              instance_exec(&block)
            end
          end
        end
      end
    end
  end
end