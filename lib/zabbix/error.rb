# frozen_string_literal: true

module Zabbix
  # Generic error to be able to rescue all Zabbix errors
  class ZabbixError < StandardError; end

  # Raised when Zabbix RPC protocol returns error object
  class RPCError < ZabbixError; end

  # Raised when Zabbix not configured correctly
  class ConfigurationError < ZabbixError; end

  # Error when authentication fails
  class AuthenticationError < ZabbixError; end
end
