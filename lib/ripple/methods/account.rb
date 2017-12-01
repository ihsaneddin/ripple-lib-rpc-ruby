module Ripple
  module Methods
    module Account
    
      #
      # ATTENTION!
      # this method should be done locally
      # this only temp and for development purpose
      # option 1 : run a local rippled server to generate wallet
      # option 2 : run a node server just to generate wallet with ripple-lib
      # option 3 : write generate ripple wallet in ruby
      #
      def wallet_propose(opts={})
        if connection_type == 'RPC'
          # RPC
          begin
            d = {
              headers: {'Accept' => "application/json; charset=utf-8", "Content-Type" => "application/json", 'User-Agent' => user_agent},
              url: "https://faucet.altnet.rippletest.net/accounts"
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

      #
      # options are:
      # account  String  A unique identifier for the account, most commonly the account's Address.
      # strict  Boolean (Optional) If true, only accept an address or public key for the account parameter. Defaults to false.
      # ledger_hash String  (Optional) A 20-byte hex string for the ledger version to use. (See Specifying a Ledger)
      # ledger_index  String or Unsigned Integer  (Optional) The sequence number of the ledger to use, or a shortcut string to choose a ledger automatically. (See Specifying a Ledger)
      #
      def account_currencies opts={}
        params= {
          account: opts.delete(:account) || client_account,
          strict: opts[:strict].nil?? true : opts[:strict],
          ledger_index: opts[:ledger_index] || "validated",
          ledger_hash: opts[:ledger_hash]
        }
        post(:account_currencies, params)
      end

      #
      # options are :
      # account String  The unique identifier of an account, typically the account's Address. The request returns channels where this account is the channel's owner/source.
      # destination_account String  (Optional) The unique identifier of an account, typically the account's Address. If provided, filter results to payment channels whose destination is this account.
      # ledger_hash String  (Optional) A 20-byte hex string for the ledger version to use. (See Specifying a Ledger)
      # ledger_index  String or Unsigned Integer  (Optional) The sequence number of the ledger to use, or a shortcut string to choose a ledger automatically. (See Specifying a Ledger)
      # limit Integer (Optional) Limit the number of transactions to retrieve. The server is not required to honor this value. Must be within the inclusive range 10 to 400. Defaults to 200.
      # marker  (Not Specified) (Optional) Value from a previous paginated response. Resume retrieving data where that response left off.
      #
      def account_channels opts= {}
        params= {
          account: opts.delete(:account) || client_account,
          destination_account: opts[:destination_account],
          ledger_index: opts[:ledger_index] || "validated",
          ledger_hash: opts[:ledger_hash],
          limit: opts[:limit]
        }
        post :account_channels, params
      end

      #
      # options are:
      # -account, String
      # -strict, Boolean
      # -ledger_hash, String
      # -ledger_index, String or Unsigned Integer
      # -queue, Boolean
      # -signer_lists, Boolean
      #
      def account_info(opts = {})
        params = {
          account: opts.delete(:account) || client_account,
          strict: opts[:strict].nil?? true : opts[:strict],
          ledger_hash: opts[:ledger_hash],
          ledger_index: opts[:ledger_index] || "validated",
        }
        post(:account_info, params)
      end

      # 
      # options are:
      # account String  A unique identifier for the account, most commonly the account's Address.
      # ledger_hash String  (Optional) A 20-byte hex string for the ledger version to use. (See Specifying a Ledger)
      # ledger_index  String or Unsigned Integer  (Optional) The sequence number of the ledger to use, or a shortcut string to choose a ledger automatically. (See Specifying a Ledger)
      # peer  String  (Optional) The Address of a second account. If provided, show only lines of trust connecting the two accounts.
      # limit Integer (Optional, default varies) Limit the number of transactions to retrieve. The server is not required to honor this value. Must be within the inclusive range 10 to 400. New in: rippled 0.26.4
      # marker  (Not Specified) (Optional) Value from a previous paginated response. Resume retrieving data where that response left off. New in: rippled 0.26.4
      #
      def account_lines opts={}
        params ={
           account: opts.delete(:account) || client_account,
           ledger: :current
        }.merge!(opts)
        post :account_lines, params
      end

      #
      # options are:
      # account String  A unique identifier for the account, most commonly the account's Address.
      # ledger  Unsigned integer, or String (Deprecated, Optional) A unique identifier for the ledger version to use, such as a ledger sequence number, a hash, or a shortcut such as "validated".
      # ledger_hash String  (Optional) A 20-byte hex string identifying the ledger version to use.
      # ledger_index  (Optional) Ledger Index (Optional, defaults to current) The sequence number of the ledger to use, or "current", "closed", or "validated" to select a ledger dynamically. (See Specifying Ledgers)
      # limit Integer (Optional, default varies) Limit the number of transactions to retrieve. The server is not required to honor this value. Must be within the inclusive range 10 to 400. New in: rippled 0.26.4
      # marker  (Not Specified) Value from a previous paginated response. Resume retrieving data where that response left off. New in: rippled 0.26.4
      #
      def account_offers(opts = {})
        params = {
          account: opts.delete(:account) || client_account,
          ledger: :current,
          ledger_index: opts[:ledger_index] || "validated",
          ledger_hash: opts[:ledger_hash],
        }
        post(:account_offers, params)
      end

      #
      # options are :
      # account String  A unique identifier for the account, most commonly the account's address.
      # type  String  (Optional) If included, filter results to include only this type of ledger object. The valid types are: offer, signer_list, state (trust line), escrow, and payment_channel.
      # ledger_hash String  (Optional) A 20-byte hex string for the ledger version to use. (See Specifying a Ledger)
      # ledger_index  String or Unsigned Integer  (Optional) The sequence number of the ledger to use, or a shortcut string to choose a ledger automatically. (See Specifying a Ledger)
      # limit Unsigned Integer  (Optional) The maximum number of objects to include in the results. Must be within the inclusive range 10 to 400 on non-admin connections. Defaults to 200.
      # marker  (Not Specified) (Optional) Value from a previous paginated response. Resume retrieving data where that response left off.
      #
      def account_object opts={}
        params ={
          account: opts.delete(:account) || client_account,
          ledger_index: opts[:ledger_index] || "validated",
          limit: opts[:limit] || 10,
          type: opts[:type] || "state"
        }
        post :account_object
      end

      #
      # options are :
      # account String  A unique identifier for the account, most commonly the account's address.
      # ledger_index_min  Integer Use to specify the earliest ledger to include transactions from. A value of -1 instructs the server to use the earliest validated ledger version available.
      # ledger_index_max  Integer Use to specify the most recent ledger to include transactions from. A value of -1 instructs the server to use the most recent validated ledger version available.
      # ledger_hash String  (Optional) Use instead of ledger_index_min and ledger_index_max to look for transactions from a single ledger only. (See Specifying a Ledger)
      # ledger_index  String or Unsigned Integer  (Optional) Use instead of ledger_index_min and ledger_index_max to look for transactions from a single ledger only. (See Specifying a Ledger)
      # binary  Boolean (Optional, defaults to False) If set to True, return transactions as hex strings instead of JSON.
      # forward boolean (Optional, defaults to False) If set to True, return values indexed with the oldest ledger first. Otherwise, the results are indexed with the newest ledger first. (Each page of results may not be internally ordered, but the pages are overall ordered.)
      # limit Integer (Optional, default varies) Limit the number of transactions to retrieve. The server is not required to honor this value.
      # marker  (Not Specified) Value from a previous paginated response. Resume retrieving data where that response left off. This value is stable even if there is a change in the server's range of available ledgers.
      #
      def account_tx(opts = {})
        params = {
          account: opts.delete(:account) || client_account,
          ledger_index_min: -1,
          ledger_index_max: -1,
          binary: false,
          count: false,
          descending: false,
          offset: 0,
          limit: 10,
          forward: false
        }.merge!(opts)
        post(:account_tx, params)
      end

      #
      # options are:
      # account String  A unique identifier for the account, most commonly the account's address.
      # role  String  Whether the address refers to a gateway or user. Recommendations depend on the role of the account. Issuers must have DefaultRipple enabled and must disable NoRipple on all trust lines. Users should have DefaultRipple disabled, and should enable NoRipple on all trust lines.
      # transactions  Boolean (Optional) If true, include an array of suggested transactions, as JSON objects, that you can sign and submit to fix the problems. Defaults to false.
      # limit Unsigned Integer  (Optional) The maximum number of trust line problems to include in the results. Defaults to 300.
      # ledger_hash String  (Optional) A 20-byte hex string for the ledger version to use. (See Specifying a Ledger)
      # ledger_index  String or Unsigned Integer  (Optional) The sequence number of the ledger to use, or a shortcut string to choose a ledger automatically. (See Specifying a Ledger)
      #
      def no_ripple_check opts={}
        params = {
          account: opts.delete(:account) || client_account,
          role: "gateway",
          limit: 2,
          ledger_index: "validated"
        }.merge!(opts)
        post(:no_ripple_check, params)
      end

      #
      # options are :
      # account String  The Address to check. This should be the issuing address
      # strict  Boolean (Optional) If true, only accept an address or public key for the account parameter. Defaults to false.
      # hotwallet String or Array An operational address to exclude from the balances issued, or an array of such addresses.
      # ledger_hash String  (Optional) A 20-byte hex string for the ledger version to use. (See Specifying a Ledger)
      # ledger_index  String or Unsigned Integer  (Optional) The sequence number of the ledger version to use, or a shortcut string to choose a ledger automatically. (See Specifying a Ledger)
      #
      def gateway_balance opts={}
        params = {
          account: opts.delete(:account) || client_account,
          strict: true, 
          hotwallet: [],
          ledger_index: 'validated'
        }.merge!(opts)
        post(:gateway_balance, params)
      end   

    end
  end
end