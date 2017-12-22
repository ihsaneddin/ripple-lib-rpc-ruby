require 'json'

module Ripple
  module Request
    
    def post(method, options = {}, endpoint=nil)
      conn_type = options[:connection_type] || connection_type
      if conn_type == 'RPC'
        # RPC
        begin
          response = connection.post do |req|
            req.url '/'
            req.body = {method: method}
            unless options.empty? || options.nil?
              req.body.merge!(params: [options])
            end
            # puts JSON(req.body)
          end
          # puts response.inspect
          Response.new(response.body)
        rescue Faraday::Error::ParsingError
          # Server unavailable
          raise ServerUnavailable
        rescue Faraday::Error::TimeoutError
          raise Timedout
        end
      else
        # Websocket
        # options[:command] = method
        # WebSocket.instance.post(options)
        rais ServerUnavailable if endpoint.nil?
        params = { command: method }.merge!(options)
        Ripple::Connection::WebSocket.instance.post(endpoint, params)
      end
    end

    #
    # for development stage
    #
    def post_offline endpoint, options ={}
      if connection_type == 'RPC'
        # RPC
        begin
          d = {
            headers: {'Accept' => "application/json; charset=utf-8", "Content-Type" => "application/json", 'User-Agent' => user_agent},
            url: "http://localhost:52134/#{endpoint}"
          }
          conn = Faraday::Connection.new(d) do |co|
            co.use FaradayMiddleware::Mashify
            co.request :json
            co.response :json
            co.use FaradayMiddleware::RaiseHttpException
            co.adapter(adapter)
          end
          response = conn.post
          # puts response.inspect
          Response.new(response.body)
        rescue Faraday::Error::ParsingError
          # Server unavailable
          raise ServerUnavailable
        rescue Faraday::Error::TimeoutError
          raise Timedout
        end
      else
        # Websocket
        # options[:command] = method
        # WebSocket.instance.post(options)
      end
    end

  end
end
