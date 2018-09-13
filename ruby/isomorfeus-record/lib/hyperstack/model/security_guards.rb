module Isomorfeus
  module Model
    class SecurityError < StandardError
    end

    module SecurityGuards
      def guarded_record_class(model_name)
        return nil unless Isomorfeus.valid_record_class_names.include?(model_name) # guard
        model_name.camelize.constantize
      end

      def guarded_record_class!(model_name)
        raise Isomorfeus::Model::SecurityError unless Isomorfeus.valid_record_class_names.include?(model_name) # guard
        model_name.camelize.constantize
      end
    end
  end
end
