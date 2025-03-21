# frozen_string_literal: true

require 'wrapi'
require File.expand_path('zabbix/version', __dir__)
require File.expand_path('zabbix/error', __dir__)
require File.expand_path('zabbix/client', __dir__)

# This module provides a Ruby API wrapper for Zabbix.
# It includes configuration options and creates client instances for interacting with the Zabbix API.
# 
# @example Initialize a Zabbix client:
#   client = Zabbix.client(endpoint: 'https://your-zabbix-server/api_jsonrpc.php')
#
module Zabbix
  extend WrAPI::Configuration
  extend WrAPI::RespondTo

  # Default User-Agent string for API requests.
  DEFAULT_UA = "Ruby Zabbix API wrapper #{Zabbix::VERSION}"

  # Creates and returns a new Zabbix client instance.
  # Merges default client settings with any user-provided options.
  #
  # @param options [Hash] Optional settings to configure the client.
  #   - `:user_agent` (String) – Custom User-Agent string for API requests.
  #   - `:endpoint` (String) – The API endpoint URL (e.g., 'https://zabbix.example.com/api_jsonrpc.php').
  #
  # @return [Zabbix::Client] A configured client instance.
  #
  # @example Create a client with a custom User-Agent and endpoint:
  #   client = Zabbix.client(user_agent: "MyApp Zabbix Client", endpoint: "https://zabbix.example.com/api_jsonrpc.php")
  #
  def self.client(options = {})
    # Ensure that the options argument is a Hash to prevent merge errors
    options = options.is_a?(Hash) ? options : {}
    Zabbix::Client.new({
      user_agent: DEFAULT_UA
    }.merge(options))
  end

  # Resets the Zabbix module configuration to its default state.
  #
  # This method sets the default endpoint and User-Agent string.
  #
  # @return [void]
  def self.reset
    super
    self.endpoint   = nil
    self.user_agent = DEFAULT_UA
  end
end
