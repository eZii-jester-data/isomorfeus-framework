module LucidHash
  class Base
    include LucidHash::Mixin

    if RUBY_ENGINE != 'opal'
      def self.inherited(base)
        Isomorfeus.add_valid_hash_class(base)

        base.prop :pub_sub_client, default: nil
        base.prop :session_id, default: nil
        base.prop :current_user, default: nil
      end
    end
  end
end