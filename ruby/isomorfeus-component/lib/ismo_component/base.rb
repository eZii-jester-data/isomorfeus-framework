module IsmoComponent
  def self.inherited(child)
    child.include(::IsmoComponent::Mixin)
  end
end