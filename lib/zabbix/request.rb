
module Zabbix
  # Deals with requests
  module Request

    # JSON-RPC is a stateless, light-weight remote procedure call (RPC) protocol. Primarily this
    # specification defines several data structures and the rules around their processing. It is
    # transport agnostic in that the concepts can be used within the same process, over sockets, over
    # http, or in many various message passing environments. It uses JSON (RFC 4627) as data format.
    #
    # https://www.jsonrpc.org/specification
    module JSONRPC2

      @@id = 1
      ZABBIX_ENDPOINT = '/zabbix/api_jsonrpc.php'

      def rpc_call(method, params = nil)
        options = {
          "jsonrpc": "2.0",
          "method": method,
          "params": {
            "output": "extend"
          },
          "id": @@id += 1
        }

        options[:params] = params if params
        result = post( ZABBIX_ENDPOINT, options )
        raise RPCError, result.body['error'] if result.body['error']

        WrAPI::Request::Entity.create(result.body['result'])
      end

    end
  end
end
