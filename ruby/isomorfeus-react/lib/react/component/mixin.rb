module React
  module Component
    module Mixin
      def self.included(base)
        base.include(::Native::Wrapper)
        base.include(::React::PropsConverters)
        base.extend(::React::PropsConverters)
        base.extend(::React::Component::NativeComponent)
        base.extend(::React::Component::ShouldComponentUpdate)
        base.extend(::React::Component::EventHandler)
        base.include(::React::Component::Elements)
        base.include(::React::Component::API)
        base.include(::React::Component::Resolution)
      end
    end
  end
end
