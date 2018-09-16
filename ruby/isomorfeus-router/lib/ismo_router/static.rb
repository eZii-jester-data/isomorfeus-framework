module IsmoRouter
  class Static
    def self.inherited(child)
      child.include(::IsmoComponent::Mixin)
      child.include(::Isomorfeus::Router::Static)
    end
  end
end