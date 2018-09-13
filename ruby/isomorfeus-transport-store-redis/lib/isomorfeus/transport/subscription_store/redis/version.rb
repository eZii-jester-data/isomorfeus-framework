module Isomorfeus
  module Transport
    module SubscriptionStore
      class Redis
        VERSION = File.read(File.expand_path("../../../../../../../ISOMORFEUS_VERSION", __dir__)).strip
      end
    end
  end
end
