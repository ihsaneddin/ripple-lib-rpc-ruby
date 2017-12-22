require 'faye/websocket'
require 'eventmachine'
require 'singleton'
require 'hashie/mash'
require 'securerandom'

module Ripple
  module Connection
    class WebSocket
      include Singleton

      def post(endpoint, params={})
        res = nil
        params[:id]||= SecureRandom.urlsafe_base64(nil, false)
        EM.run {
          ws = Faye::WebSocket::Client.new(endpoint)

          ws.on :open do |event|
            p [:open]
            ws.send(params.to_json)
          end

          ws.on :message do |event|
            p [:message, event.data]
            res = Hashie::Mash.new(JSON.parse(event.data))
            ws.close
          end

          ws.on :close do |event|
            p [:close, event.code, event.reason]
            ws = nil
            EM.stop_event_loop
          end
        }
        res.id= params[:id]
        res
      end

    end
  end
end
