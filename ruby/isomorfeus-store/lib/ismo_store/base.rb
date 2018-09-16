module IsmoStore
  class << self
    def inherited(child)
      child.include(::IsmoStore::Mixin)
    end
  end
  def initialize
    init_store
  end
end
