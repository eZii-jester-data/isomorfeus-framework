module IsmoRecord
  module Mixin
    def self.included(base)
      if RUBY_ENGINE == 'opal'
        base.extend(Isomorfeus::Record::ClientClassMethods)
        base.extend(Isomorfeus::Record::ClientClassProcessor)
        base.include(Isomorfeus::Record::ClientInstanceMethods)
        base.include(Isomorfeus::Record::ClientInstanceProcessor)
        base.class_eval do
          scope :all
        end
      else
        base.extend(Isomorfeus::Record::ServerClassMethods)
        base.include(Isomorfeus::Record::ServerInstanceMethods)
      end
    end
  end
end
