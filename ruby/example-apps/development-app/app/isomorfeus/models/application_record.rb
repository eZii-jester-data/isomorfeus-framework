if RUBY_ENGINE == 'opal'
  class ApplicationRecord
    def self.inherited(base)
      base.include(LucidRecord::Mixin)
    end
  end
else
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end