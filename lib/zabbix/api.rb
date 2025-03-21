# frozen_string_literal: true

require 'wrapi'
require File.expand_path('request', __dir__)
require File.expand_path('authentication', __dir__)

module Zabbix
  # This class is the core API client that interfaces with Zabbix.
  # It manages configuration options, API connections, and helper utilities.
  #
  # @example Create a new Zabbix API client:
  #    api = Zabbix::API.new(endpoint: 'https://zabbix.example.com/api_jsonrpc.php', api_key: 'your_key')
  #
  # @note This class includes connection, request handling, JSON-RPC 2.0 support, and authentication from WrAPI.
  class API
    # Allow read/write access to configuration keys like endpoint, user_agent, and others.
    # These keys are inherited from `WrAPI::Configuration::VALID_OPTIONS_KEYS`.
    #
    # @!attribute [rw] endpoint
    #   @return [String] The base URL of the Zabbix API.
    # @!attribute [rw] user_agent
    #   @return [String] The user agent used in API requests.
    attr_accessor(*WrAPI::Configuration::VALID_OPTIONS_KEYS)

    # Initialize a new Zabbix::API instance and copy settings from the singleton configuration.
    #
    # @param options [Hash] Configuration options for the Zabbix API client.
    #   Options override any default values set in the singleton Zabbix configuration.
    #
    # @option options [String] :endpoint The base URL of the Zabbix API.
    # @option options [String] :user_agent The User-Agent header sent with requests.
    # @option options [Integer] :timeout Request timeout in seconds.
    def initialize(options = {})
      options = Zabbix.options.merge(options)  # Merge provided options with default options
      WrAPI::Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])  # Assign each configuration option dynamically
      end
    end

    # Retrieve the current configuration for the API client.
    #
    # @return [Hash] A hash containing the current configuration options.
    # @example Get the client configuration:
    #   api = Zabbix::API.new
    #   puts api.config  # => { endpoint: "https://...", user_agent: "...", timeout: 60 }
    def config
      conf = {}
      WrAPI::Configuration::VALID_OPTIONS_KEYS.each do |key|
        conf[key] = send(key)  # Build a hash of current configuration values
      end
      conf
    end

    # Convert a Zabbix clock timestamp to a Ruby DateTime object.
    #
    # @param secs [String, Integer] The Zabbix clock time in seconds since the Unix epoch.
    # @return [DateTime] A DateTime object representing the input time.
    #
    # @example Convert Zabbix clock to DateTime:
    #   api.zabbix_clock(1684500000)  # => #<DateTime: 2023-05-19T09:20:00+00:00>
    def zabbix_clock(secs)
      Time.at(secs.to_i).to_datetime  # Convert seconds since Unix epoch to DateTime
    end

    # Includes core modules from WrAPI and Zabbix:
    # - Connection: For managing HTTP connections.
    # - Request: For handling JSON-RPC 2.0 requests.
    # - Authentication: For managing API authentication.
    include WrAPI::Connection
    include WrAPI::Request
    include Request::JSONRPC2
    include WrAPI::Authentication
    include Authentication
  end
end
