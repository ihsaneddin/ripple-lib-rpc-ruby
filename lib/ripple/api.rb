require File.expand_path('../connection', __FILE__)
require File.expand_path('../request', __FILE__)

require 'socket'
require 'timeout'

module Ripple
  # @private
  class API
    include Connection
    include Request
    
    # @private
    attr_accessor *Configuration::VALID_OPTIONS_KEYS
    attr_accessor :node_ripple_lib

    # Creates a new API
    def initialize(options = {})
      options = Ripple.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    #
    # for development stage only
    #
    def start_node_ripple_lib
      unless is_port_open?("127.0.0.1", 52134)
        current_dir = File.dirname(__FILE__).split("/")
        current_dir.pop 2
        current_dir = current_dir + Array('node')
        current_dir = current_dir.join('/')
        system("cd #{current_dir} && node server.js &")
      end
      self.node_ripple_lib= true
    end

    def is_port_open?(ip="127.0.0.1", port)
      begin
        Timeout::timeout(1) do
          begin
            s = TCPSocket.new(ip, port)
            s.close
            return true
          rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
            return false
          end
        end
      rescue Timeout::Error
      end

      return false
    end

  end
end
