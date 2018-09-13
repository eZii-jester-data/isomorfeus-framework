module Isomorfeus
  class Router
    def self.inherited(child)
      child.include(Isomorfeus::Component::Mixin)
      child.include(Base)
    end
  end

  class BrowserRouter
    def self.inherited(child)
      child.include(Isomorfeus::Component::Mixin)
      child.include(Isomorfeus::Router::Browser)
    end
  end

  class HashRouter
    def self.inherited(child)
      child.include(Isomorfeus::Component::Mixin)
      child.include(Isomorfeus::Router::Hash)
    end
  end

  class MemoryRouter
    def self.inherited(child)
      child.include(Isomorfeus::Component::Mixin)
      child.include(Isomorfeus::Router::Memory)
    end
  end

  class StaticRouter
    def self.inherited(child)
      child.include(Isomorfeus::Component::Mixin)
      child.include(Isomorfeus::Router::Static)
    end
  end
end
