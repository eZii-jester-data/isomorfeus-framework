module IsmoComponent
  class Base
    def self.inherited(child)
      child.include(::IsmoComponent::Mixin)
    end
  end
end
