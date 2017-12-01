#
# dev public rH64qTtDUhPQqkh9WPp5X7JUEZdfxZcCvQ
# dev secret sh1EL4uyJ9hKZQWBBmfd6LMC9hwzG
#

Dir[File.expand_path('../methods/*.rb', __FILE__)].each{|f| require f}

module Ripple
  class Client < API

    ####################
    # Low level methods
    ####################

    include Ripple::Methods::Account, Ripple::Methods::Ledger, Ripple::Methods::Transaction, Ripple::Methods::Utils

  end
end
