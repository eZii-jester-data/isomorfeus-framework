module Isomorfeus
  module Transport
    module ActionCable
      VERSION = File.read(File.expand_path("../../../../../../HYPERSTACK_VERSION", __dir__)).strip
    end
  end
end
