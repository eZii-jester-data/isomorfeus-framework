module React
  module Component
    class Location
      include ::Native::Wrapper

      alias _original_method_missing method_missing

      def method_missing(prop, *args, &block)
        @native.JS[:params].JS[prop]
      end

      def to_n
        @native
      end
    end
  end
end