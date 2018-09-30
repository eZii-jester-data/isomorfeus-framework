module React
  module Component
    class Props
      include ::Native::Wrapper
      include ::React::PropsConverters

      alias _original_method_missing method_missing

      def method_missing(prop, *args, &block)
        @native.JS[:props].JS[lower_camelize(prop)]
      end

      def to_n
        @native.JS[:props]
      end
    end
  end
end