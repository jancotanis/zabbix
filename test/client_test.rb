# frozen_string_literal: true

require 'logger'
require 'test_helper'

CLIENT_LOGGER = 'client_test.log'
File.delete(CLIENT_LOGGER) if File.exist?(CLIENT_LOGGER)

describe 'client' do
  before do
    Dotenv.load
    Zabbix.configure do |config|
      config.endpoint = ENV['ZABBIX_API_HOST']
      config.access_token = ENV['ZABBIX_API_KEY']
      config.logger = Logger.new(CLIENT_LOGGER)
    end
    @client = Zabbix.client
  end
  it '#0 GET zabbix clock' do
    t = @client.zabbix_clock(0)
    assert value(t.year).must_equal 1970, '0 time is 1-1-1970'
    assert value(t.day).must_equal 1, '0 time is 1-1-1970'
    assert value(t.month).must_equal 1, '0 time is 1-1-1970'
  end
  it '#1 GET hostgroups.get' do
    hostgroups = @client.hostgroups
    assert hostgroups.any?, '.hostgroups found"'
    refute hostgroups.first.name.empty?, 'hostgroups[].name not empty'
    assert value(hostgroups.first.name).must_equal(@client.hostgroup(hostgroups.first.groupid).name), 'hostgroup vs hostgroups'
  end
  it '#2 GET host.get' do
    # just get them and try a parameter
    hosts = @client.hosts
    assert hosts.any?, '.hosts found'
    refute hosts.first.name.empty?, 'host[].name not empty'
    assert value(hosts.first.name).must_equal(@client.host(hosts.first.hostid).name), 'host vs hosts'
  end
  it '#3 GET problem.get' do
    # just get them and try a parameter
    all_problems = @client.problems
    assert all_problems.any?, '.problems found'
    refute all_problems.first.name.empty?, 'problem[].name not empty'
    assert value(all_problems.first.name).must_equal(@client.problem(all_problems.first.eventid).name), 'problems vs client problems'

    # get all problems for first group
    problems = @client.problems({ groupids: [@client.hostgroups.first.groupid] })
    assert problems.count < all_problems.count, 'should be less problems for a asingle group'
  end
  it '#4 GET events.get' do
    problem = @client.problems.first
    events = @client.events({ 'eventids': [problem.eventid], 'selectHosts': ['hostid'] })

    assert events, 'event not nil'
    event = events.first
    assert event.hosts.first.hostid, 'hosts.first.hostid not nil'
    result = @client.acknowledge_events({ 'eventids': [event.eventid], 'action': '2' })
    assert value(events.first.name).must_equal(@client.event(events.first.eventid).name), 'event vs events'

    # for some reason evendid is a string but and int when returned as result from acknowledging
    assert result.eventids.include?(event.eventid.to_i), 'result should include acknowledged events'
  end
end
