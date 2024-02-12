# Zabbix API

This is a wrapper for the Zabix rest API. You can see the API endpoints here https://www.zabbix.com/documentation/current/en/manual/api/reference/

Currently only the GET requests to get a list of hosts, host groups and problems are implemented.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'zabbix_api_gem'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install zabbix_api_gem

## Usage

Before you start making the requests to API provide the client id and client secret and email/password using the configuration wrapping.

```
require 'zabbix_api_gem'

# use do block
Zabbix.configure do |config|
  config.endpoint = ENV["ZABBIX_API_HOST"]
  config.access_token = ENV["ZABBIX_API_KEY"]
end

# or configure with options hash
client = Zabbix.client({ logger: Logger.new(CLIENT_LOGGER) })

client = Zabbix.client
client.login

hostgroups = client.hostgroups
companies.each do |c|
  puts "#{c.name}"
end
```

## Resources
### Authentication
```
# setup configuration
#
client.login
```
|Resource|API endpoint|Description|
|:--|:--|:--|
|.login| none |uses settings.get to check if credentials are correct. Raises Zabbix:AuthenticationError incase this fails|


### Server settings
Return zabbix server settings
```
puts client.settings.default_theme
```

|Resource|API endpoint|
|:--|:--|
|.settings|settings.get|



### Data resourcews
Endpoint for data related requests 
```
groups = client.hostgroups
group_hosts = client.hosts({groupids:[groups.first.groupid]})

group_hosts.each do |host|
  client.problems({hostids:[host.hostid]}).each do |problem|
    puts problem.name
  end
end
```

|Resource|API endpoint|
|:--|:--|
|.hostgroups|hostgroup.get|
|.hosts|hosts.get|
|.problems|problems.get|



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jancotanis/veeam.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
