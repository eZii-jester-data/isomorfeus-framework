module LucidRecord
  class Base
    def self.inherited(base)
      base.include(::LucidRecord::Mixin)
    end
  end
end
