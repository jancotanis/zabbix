
module Zabbix
  # Deals with authentication flow and stores it within global configuration
  module Authentication

    # Authorize to the Zabbix portal using the access_token
    # @see https://www.zabbix.com/documentation/current/en/manual/api
    def login(options = {})
      raise ConfigurationError, "Accesstoken/api-key not set" unless access_token
      # only bearer token needed 
      # will do sanity check if token if valid
      rpc_call('settings.get')
    rescue RPCError => e
      raise AuthenticationError, e
    end

  end
end
