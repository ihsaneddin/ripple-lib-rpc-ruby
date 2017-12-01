module Ripple
  module Methods
    module Utils
    
      def ping
        post(:ping)
      end

      def server_info
        post(:server_info)
      end

      def server_state
        post(:server_state)
      end

    end
  end
end