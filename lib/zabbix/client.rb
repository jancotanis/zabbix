require File.expand_path('api', __dir__)

module Zabbix
  # Wrapper for the Zabbix REST API
  #
  # @note All methods have been separated into modules and follow the same grouping used in api docs
  # @see https://www.zabbix.com/documentation/current/en/manual/api
  class Client < API

    def self.def_rpc_call(method, rpc_method)
      self.send(:define_method, method) do |params = nil|
        rpc_call(rpc_method, params)
      end
    end

    def_rpc_call(:api_info, 'api.info')
    def_rpc_call(:settings, 'settings.get')
    def_rpc_call(:hostgroups, 'hostgroup.get')
    def_rpc_call(:hosts, 'host.get')
    def_rpc_call(:problems, 'problem.get')

  end
end
