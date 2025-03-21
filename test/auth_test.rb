# frozen_string_literal: true

require 'logger'
require 'test_helper'

AUTH_LOGGER = 'auth_test.log'
File.delete(AUTH_LOGGER) if File.exist?(AUTH_LOGGER)

describe 'auth' do
  before do
    Zabbix.reset
    Zabbix.logger = Logger.new(AUTH_LOGGER)
  end
  it '#0 check required params' do
    c = Zabbix.client
    # missing endpoint
    assert_raises Zabbix::ConfigurationError do
      c.login
    end
  end
  it '#1 check required params' do
    Zabbix.configure do |config|
      config.endpoint = ENV['ZABBIX_API_HOST']
    end
    c = Zabbix.client
    # missing access_token
    assert_raises Zabbix::ConfigurationError do
      c.login
    end
  end
  it '#2 wrong credentials' do
    Zabbix.configure do |config|
      config.endpoint = ENV['ZABBIX_API_HOST']
      config.access_token = 'api-key-token'
    end
    c = Zabbix.client
    assert_raises Zabbix::AuthenticationError do
      c.login
    end
  end
  it '#3 logged in' do
    Zabbix.configure do |config|
      config.endpoint = ENV['ZABBIX_API_HOST']
      config.access_token = ENV['ZABBIX_API_KEY']
    end
    c = Zabbix.client

    refute_empty c.login, '.login'
  end
end
