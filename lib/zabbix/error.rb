module Zabbix
	
  # Generic error to be able to rescue all Zabbix errors
  class ZabbixError < StandardError; end

  # Raised when Zabbix RPC protocol returns error object
  class RPCError < ZabbixError; end

  # Error when authentication fails
  class AuthenticationError < ZabbixError; end
end