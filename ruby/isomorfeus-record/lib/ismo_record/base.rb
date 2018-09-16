module IsmoRecord
  class Base
    def self.inherited(base)
      base.include(::IsmoRecord::Mixin)
    end
  end
end
