module Isomorfeus
  class Component
    def self.inherited(child)
      child.include(Mixin)
    end
  end
end