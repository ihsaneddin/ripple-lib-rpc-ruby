require File.expand_path('../ripple/error', __FILE__)
require File.expand_path('../ripple/configuration', __FILE__)
require File.expand_path('../ripple/api', __FILE__)
require File.expand_path('../ripple/models/path', __FILE__)
require File.expand_path('../ripple/models/amount', __FILE__)
require File.expand_path('../ripple/models/transaction', __FILE__)
require File.expand_path('../ripple/models/account_info', __FILE__)
require File.expand_path('../ripple/models/account_lines', __FILE__)
require File.expand_path('../ripple/client', __FILE__)
require File.expand_path('../ripple/extensions/federation', __FILE__)
require File.expand_path('../ripple/abstract', __FILE__)
require File.expand_path('../ripple/request', __FILE__)
require File.expand_path('../ripple/response', __FILE__)
require File.expand_path('../ripple/methods/account', __FILE__)
require File.expand_path('../ripple/methods/ledger', __FILE__)
require File.expand_path('../ripple/methods/transaction', __FILE__)
require File.expand_path('../ripple/methods/utils', __FILE__)
require File.expand_path('../ripple/websocket', __FILE__)

module Ripple
  extend Configuration

  # Alias for Ripple::Client.new
  #
  # @return [Ripple::Client]
  def self.client(options={})
    Ripple::Abstract.new(options)
  end

  def self.federation #(method, *args, &block)
    Ripple::Federation.new #.send(method, *args, &block)
  end

  # Delegate to Ripple::Abstract
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  # Delegate to Ripple::Abstract
  def self.respond_to?(method)
    return client.respond_to?(method) || super
  end
end
