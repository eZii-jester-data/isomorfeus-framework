if RUBY_ENGINE == 'opal'
  class ApplicationRecord
    include LucidRecord::Mixin
  end
else
  class ApplicationRecord < ActiveRecord::Base
    include LucidRecord::Mixin
    self.abstract_class = true
  end
end