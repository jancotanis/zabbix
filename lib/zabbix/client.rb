require File.expand_path('api', __dir__)

module Zabbix
  # Wrapper for the Zabbix REST API
  #
  # @note All methods have been separated into modules and follow the same grouping used in api docs
  # @see https://www.zabbix.com/documentation/current/en/manual/api
  class Client < API
  private
    def self.def_rpc_call(method, rpc_method, id_field = nil)
      self.send(:define_method, method) do |params = nil|
        rpc_call(rpc_method, params)
      end
      if id_field
        # strip trailing 's'
        singular = method.to_s.chop.to_sym
        self.send(:define_method, singular) do |ids,params = nil|
          if ids.is_a?(Array)
            rpc_call(rpc_method, {"#{id_field}":ids}.merge(params || {}))
          else
            rpc_call(rpc_method, {"#{id_field}":[ids]}.merge(params || {})).first
          end
        end
      end
    end

  public
    def_rpc_call :api_info, 'api.info'
    def_rpc_call :settings, 'settings.get'
    def_rpc_call :hostgroups, 'hostgroup.get', 'groupids'
    def_rpc_call :hosts, 'host.get', 'hostids'
    def_rpc_call :problems, 'problem.get', 'problemids'
    def_rpc_call :events, 'event.get', 'eventids'
    def_rpc_call :acknowledge_events, 'event.acknowledge'

  end
end
