# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require 'Dotenv'
require 'zabbix_api_gem'
require 'minitest/autorun'
require 'minitest/spec'

Dotenv.load
