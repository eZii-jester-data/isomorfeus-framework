module IsmoStore
  class Base
    def self.inherited(child)
      child.include(::IsmoStore::Mixin)
    end

    def initialize
      init_store
    end
  end
end
