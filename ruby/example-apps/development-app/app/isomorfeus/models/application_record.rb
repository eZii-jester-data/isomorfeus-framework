class ApplicationRecord
  def self.inherited(base)
    base.include(LucidRecord::Mixin)
  end
  if RUBY_ENGINE == 'opal'
    # nothing yet
  else
    self.abstract_class = true
  end
end
