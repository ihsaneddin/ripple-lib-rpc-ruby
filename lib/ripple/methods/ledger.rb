module Ripple
  module Methods
    module Ledger
    
      def ledger(opts = {})
        params = {
          full: opts[:full] || false,
          expand: opts[:expand] || false,
          transactions: opts[:transactions] || true,
          accounts: opts[:accounts] || true
        }
        post(:ledger, params)
      end

      def ledger_closed
        post(:ledger_closed)
      end

      def ledger_current
        post(:ledger_current)
      end

      def ledger_entry
        params = {
          type: :account_root,
          account_root: client_account,
          ledger_hash: :validated
        }
        post(:ledger_entry, params)
      end

      #
      # WebSocket API only! The path_find method searches for a path along which a transaction
      # The create subcommand of path_find creates an ongoing request to find possible paths along which a payment transaction could be made from one specified account such that another account receives a desired amount of some currency. 
      # this function is subcommand from `path_find`
      # options are :
      # subcommand  String  Use "create" to send the create subcommand
      # source_account  String  Unique address of the account to find a path from. (In other words, the account that would be sending a payment.)
      # destination_account String  Unique address of the account to find a path to. (In other words, the account that would receive a payment.)
      # destination_amount  String or Object  Currency amount that the destination account would receive in a transaction. Special case: New in: rippled 0.30.0 You can specify "-1" (for XRP) or provide -1 as the contents of the value field (for non-XRP currencies). This requests a path to deliver as much as possible, while spending no more than the amount specified in send_max (if provided).
      # send_max  String or Object  (Optional) Currency amount that would be spent in the transaction. Not compatible with source_currencies. New in: rippled 0.30.0
      # paths Array (Optional) Array of arrays of objects, representing payment paths to check. You can use this to keep updated on changes to particular paths you already know about, or to check the overall cost to make a payment along a certain path.
      #
      def path_find_create opts={}
        params= {
          source_account: nil,
          destination_account: nil,
          destination_amount: {
              value: nil,
              currency: nil,
              issuer: opts.delete(:account) || client_account
          }
        }.merge!(opts)
        post(:path_find, params.merge!(subcommand: "create", connection_type: "WebSocket"), self.websocket_endpoint)
      end

      #
      # The close subcommand of path_find instructs the server to stop sending information about the current open pathfinding request.
      #
      def path_find_close(opts={})
        post(:path_find, opts.merge!(subcommand: "close", connection_type: "WebSocket"), self.websocket_endpoint)
      end

      #
      # The status subcommand of path_find requests an immediate update about the client's currently-open pathfinding request.
      #
      def path_find_status(opts={})
        post(:path_find, opts.merge(subcommand: "status", connection_type: "WebSocket"), self.websocket_endpoint)
      end

      #
      # The ripple_path_find method is a simplified version of path_find that provides a single response with a payment path you can use right away. 
      # options are:
      # source_account  String  Unique address of the account that would send funds in a transaction
      # destination_account String  Unique address of the account that would receive funds in a transaction
      # destination_amount  String or Object  Currency amount that the destination account would receive in a transaction. Special case: New in: rippled 0.30.0 You can specify "-1" (for XRP) or provide -1 as the contents of the value field (for non-XRP currencies). This requests a path to deliver as much as possible, while spending no more than the amount specified in send_max (if provided).
      # send_max  String or Object  (Optional) Currency amount that would be spent in the transaction. Cannot be used with source_currencies. New in: rippled 0.30.0
      # source_currencies Array (Optional) Array of currencies that the source account might want to spend. Each entry in the array should be a JSON object with a mandatory currency field and optional issuer field, like how currency amounts are specified. Cannot contain more than 18 source currencies. By default, uses all source currencies available up to a maximum of 88 different currency/issuer pairs.
      # ledger_hash String  (Optional) A 20-byte hex string for the ledger version to use. (See Specifying a Ledger)
      # ledger_index  String or Unsigned Integer  (Optional) The sequence number of the ledger to use, or a shortcut string to choose a ledger automatically. (See Specifying a Ledger)
      #
      def ripple_path_find(opts = {})
        params = {
          source_account: opts[:source_account] || client_account,
          destination_account: opts[:destination_account],
          destination_amount: opts[:destination_amount],
          source_currencies: opts[:source_currencies]
          # ledger_hash: ledger         # optional
          # "ledger_index" : ledger_index   // optional, defaults 'current'
        }
        # puts JSON(params)
        post(:ripple_path_find, params)
      end

    end
  end
end