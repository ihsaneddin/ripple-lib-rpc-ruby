module Ripple
  module Methods
    module Transaction


      #
      # TODO
      # The book_offers method retrieves a list of offers, also known as the order book, between two currencies
      # options are:
      # ledger_hash String  (Optional) A 20-byte hex string for the ledger version to use. (See Specifying a Ledger)
      # ledger_index  String or Unsigned Integer  (Optional) The sequence number of the ledger to use, or a shortcut string to choose a ledger automatically. (See Specifying a Ledger)
      # limit Unsigned Integer  (Optional) If provided, the server does not provide more than this many offers in the results. The total number of results returned may be fewer than the limit, because the server omits unfunded offers.
      # taker String  (Optional) The Address of an account to use as a perspective. Unfunded offers placed by this account are always included in the response. (You can use this to look up your own orders to cancel them.)
      # taker_gets  Object  Specification of which currency the account taking the offer would receive, as an object with currency and issuer fields (omit issuer for XRP), like currency amounts.
      # taker_pays  Object  Specification of which currency the account taking the offer would pay, as an object with currency and issuer fields (omit issuer for XRP), like currency amounts.
      #
      def book_offers opts=[]

      end
    
      # Parameters for opts
      # tx_json Object  Transaction definition in JSON format
      # secret  String  (Optional) Secret key of the account supplying the transaction, used to sign it. Do not send your secret to untrusted servers or through unsecured network connections. Cannot be used with key_type, seed, seed_hex, or passphrase.
      # seed  String  (Optional) Secret key of the account supplying the transaction, used to sign it. Must be in base58 format. If provided, you must also specify the key_type. Cannot be used with secret, seed_hex, or passphrase.
      # seed_hex  String  (Optional) Secret key of the account supplying the transaction, used to sign it. Must be in hexadecimal format. If provided, you must also specify the key_type. Cannot be used with secret, seed, or passphrase.
      # passphrase  String  (Optional) Secret key of the account supplying the transaction, used to sign it, as a string passphrase. If provided, you must also specify the key_type. Cannot be used with secret, seed, or seed_hex.
      # key_type  String  (Optional) Type of cryptographic key provided in this request. Valid types are secp256k1 or ed25519. Defaults to secp256k1. Cannot be used with secret. Caution: Ed25519 support is experimental.
      # offline Boolean (Optional, defaults to false) If true, when constructing the transaction, do not try to automatically fill in or validate values.
      # build_path  Boolean (Optional) If provided for a Payment-type transaction, automatically fill in the Paths field before signing. Caution: The server looks for the presence or absence of this field, not its value. This behavior may change.
      # fee_mult_max  Integer (Optional, defaults to 10; recommended value 1000) Limits how high the automatically-provided Fee field can be. Signing fails with the error rpcHIGH_FEE if the current load multiplier on the transaction cost is greater than (fee_mult_max ÷ fee_div_max). Ignored if you specify the Fee field of the transaction (transaction cost).
      # fee_div_max Integer (Optional, defaults to 1) Signing fails with the error rpcHIGH_FEE if the current load multiplier on the transaction cost is greater than (fee_mult_max ÷ fee_div_max). Ignored if you specify the Fee field of the transaction (transaction cost). New in: rippled 0.30.1
      #
      # :tx_blob           // Optional. Replaces all other parameters. Raw transaction
      # :transaction_type  // Optional. Default: 'Payment'
      # :destination       // Destination account
      # :amount            // Ammount to send
      # :SendMax           // Optional. Complex IOU send
      # :Paths             // Optional. Complex IOU send
      def sign(opts = {})
        params = {
          secret: client_secret,
          offline: opts[:offline] || false,
          tx_json: {
            'TransactionType' => opts[:transaction_type] || 'Payment',
            'Account' => client_account,
            'Destination' => opts[:destination],
            'Amount' => opts[:amount],
          }
        }
        if opts.key?(:SendMax) and opts.key?(:Paths)
            # Complex IOU send
            params[:tx_json]['SendMax'] = opts[:SendMax]
            params[:tx_json]['Paths'] = opts[:Paths]
          end
        if opts.key?(:DestinationTag)
          params[:tx_json]['DestinationTag'] = opts[:DestinationTag]
        end
        if opts.key?(:InvoiceID)
          params[:tx_json]['InvoiceID'] = opts[:InvoiceID]
        end
        post(:sign, params)
      end

      # Parameters for opts
      # :tx_blob           // Optional. Replaces all other parameters. Raw transaction
      # :transaction_type  // Optional. Default: 'Payment'
      # :destination       // Destination account
      # :amount            // Ammount to send
      # :SendMax           // Optional. Complex IOU send
      # :Paths             // Optional. Complex IOU send
      def submit(opts = {})
        params = {
          secret: client_secret,
        }
        if opts.key?(:tx_blob)
          params.merge!(opts)
        else
          params.merge!({tx_json: {
            'TransactionType' => opts[:transaction_type] || 'Payment',
            'Account' => client_account,
            'Destination' => opts[:destination],
            'Amount' => opts[:amount]
          }})

          if opts.key?(:SendMax) and opts.key?(:Paths)
            # Complex IOU send
            params[:tx_json]['SendMax'] = opts[:SendMax]
            params[:tx_json]['Paths'] = opts[:Paths]
          end
          if opts.key?(:DestinationTag)
            params[:tx_json]['DestinationTag'] = opts[:DestinationTag]
          end
          if opts.key?(:InvoiceID)
            params[:tx_json]['InvoiceID'] = opts[:InvoiceID]
          end
        end
        # puts "Submit: " + params.inspect
        post(:submit, params)
      end

      def transaction_entry(opts={})
        params = {
          tx_hash: tx_hash,
          ledger_index: ledger_index
        }
        post(:transaction_entry, params)
      end

      def tx(tx_hash)
        post(:tx, {transaction: tx_hash})
      end

      def tx_history(start = 0)
        post(:tx_history, {start: start})
      end

    end
  end
end
