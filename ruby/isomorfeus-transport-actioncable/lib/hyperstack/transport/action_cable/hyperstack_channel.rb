module Isomorfeus
  module Transport
    module ActionCable
      class IsomorfeusChannel < ::ActionCable::Channel::Base
        def subscribed
          stream_from "#{params[:session_id]}"
        end
      end
    end
  end
end