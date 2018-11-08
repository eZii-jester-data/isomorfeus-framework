module LucidRecord
  module Mixin
    def self.included(base)
      if RUBY_ENGINE == 'opal'
        base.extend(::Isomorfeus::Record::Opal::ClassMethods)
        base.extend(::Isomorfeus::Record::Opal::Relations)
        base.extend(::Isomorfeus::Record::Opal::RemoteMethods)
        base.extend(::Isomorfeus::Record::Opal::Scopes)
        base.include(::Isomorfeus::Record::Opal::InstanceMethods)
        base.include(::Isomorfeus::Record::CommonInstanceMethods)
        base.class_eval do
          scope :all
        end
      else
        base.extend(::Isomorfeus::Record::Ruby::ClassMethods)
        base.extend(::Isomorfeus::Record::Ruby::Relations)
        base.extend(::Isomorfeus::Record::Ruby::RemoteMethods)
        base.extend(::Isomorfeus::Record::Ruby::Scopes)
        base.include(::Isomorfeus::Record::Ruby::InstanceMethods)
        base.include(::Isomorfeus::Record::CommonInstanceMethods)
      end
    end
  end
end
