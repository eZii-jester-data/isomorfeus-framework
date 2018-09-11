module Hyperstack
  module Transport
    class RackMiddleware
      include Hyperstack::Transport::RequestProcessor

      def initialize(app)
        @app = app
      end

      def call(env)
        if env['PATH_INFO'] == Hyperstack.api_path && env['REQUEST_METHOD'] == 'POST'
          request = Rack::Request.new(env)
          unless request.body.nil?
            request_hash = Oj.load(request.body.read, symbol_keys: false)

            result = if defined?(Warden::Manager)
                       user = env['warden'].user
                       if Hyperstack.transport_middleware_require_user
                         return @app.call(env) unless user
                       end
                       process_request(env['rack.session'].id, user, request_hash)
                     else
                       process_request(env.session.id, nil, request_hash)
                     end
            Rack::Response.new(Oj.dump(result, symbol_keys: false), 200, 'Content-Type' => 'application/json').finish
          end
        else
          @app.call(env)
        end
      end
    end
  end
end