require "wrapi"
require File.expand_path('request', __dir__)
require File.expand_path('authentication', __dir__)

module Zabbix
  # @private
  class API

    # @private
    attr_accessor *WrAPI::Configuration::VALID_OPTIONS_KEYS

    # Creates a new API and copies settings from singleton
    def initialize(options = {})
      options = Zabbix.options.merge(options)
      WrAPI::Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    def config
      conf = {}
      WrAPI::Configuration::VALID_OPTIONS_KEYS.each do |key|
        conf[key] = send key
      end
      conf
    end

    # Convert zabbix clock to datetime
    def zabbix_clock secs
      Time.at( secs.to_i ).to_datetime
    end

    include WrAPI::Connection
    include WrAPI::Request
    include Request::JSONRPC2
    include WrAPI::Authentication
    include Authentication
  end
end
