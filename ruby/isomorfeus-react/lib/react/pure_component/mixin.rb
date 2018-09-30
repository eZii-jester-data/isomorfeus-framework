module React
  module PureComponent
    module Mixin
      def self.included(base)
        base.include(::Native::Wrapper)
        base.include(::React::PropsConverters)
        base.extend(::React::PropsConverters)
        base.extend(::React::PureComponent::NativeComponent)
        base.extend(::React::Component::EventHandler)
        base.include(::React::Component::Elements)
        base.include(::React::Component::API)
        base.include(::React::Component::Resolution)
      end
    end
  end
end
