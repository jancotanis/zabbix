require "wrapi"
require File.expand_path('zabbix/version', __dir__)
require File.expand_path('zabbix/error', __dir__)
require File.expand_path('zabbix/client', __dir__)

module Zabbix
  extend WrAPI::Configuration
  extend WrAPI::RespondTo

  DEFAULT_UA       = "Ruby Zabbix API wrapper #{Zabbix::VERSION}".freeze

  #
  # @return [Zabbix::Client]
  def self.client(options = {})
    Zabbix::Client.new({
      user_agent: DEFAULT_UA
    }.merge(options))
  end

  def self.reset
    super
    self.endpoint     = nil
    self.user_agent   = DEFAULT_UA
  end
end
