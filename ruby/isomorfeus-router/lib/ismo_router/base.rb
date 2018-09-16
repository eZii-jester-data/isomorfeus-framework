module IsmoRouter
  class Base
    def self.inherited(child)
      child.include(::IsmoRouter::Mixin)
    end
  end
end
