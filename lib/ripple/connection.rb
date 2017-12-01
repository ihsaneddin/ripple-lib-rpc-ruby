require 'json'
require 'faraday_middleware'
Dir[File.expand_path('../../faraday/*.rb', __FILE__)].each{|f| require f}

module Ripple
  # @private
  module Connection
    private

    def connection
      options = {
        headers: {'Accept' => "application/json; charset=utf-8", "Content-Type" => "application/json", 'User-Agent' => user_agent},
        url: endpoint
      }

      Faraday::Connection.new(options) do |connection|
        connection.use FaradayMiddleware::Mashify
        connection.request :json
        connection.response :json
        connection.use FaradayMiddleware::RaiseHttpException
        connection.adapter(adapter)
      end
    end
  end
end
