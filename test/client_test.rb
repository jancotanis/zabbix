require 'Dotenv'
require 'logger'
require "test_helper"

CLIENT_LOGGER = "client_test.log"
File.delete(CLIENT_LOGGER) if File.exist?(CLIENT_LOGGER)

describe 'client' do
  before do
    Dotenv.load
    Zabbix.configure do |config|
      config.endpoint = ENV["ZABBIX_API_HOST"]
      config.access_token = ENV["ZABBIX_API_KEY"]
      config.logger = Logger.new(CLIENT_LOGGER)
    end
    @client = Zabbix.client()
  end

  it "#1 GET hostgroups.get" do
    hostgroups = @client.hostgroups
    assert hostgroups.count > 0, ".hostgroups found" 
    refute hostgroups.first.name.empty?, "hostgroups[].name not empty"
  end
  it "#1 GET host.get" do
    # just get them and try a parameter
    hosts = @client.hosts
    assert hosts.count > 0, ".hostgroups found" 
    refute hosts.first.name.empty?, "host[].name not empty"
  end
  it "#1 GET problem.get" do
    # just get them and try a parameter
    all_problems = @client.problems
    assert all_problems.count > 0, ".hostgroups found" 
    refute all_problems.first.name.empty?, "problem[].name not empty"
    
    # get all problems for first group
    problems = @client.problems({groupids: [@client.hostgroups.first.groupid]})
    assert problems.count < all_problems.count, "should be less problems for a asingle group"
  end
end
