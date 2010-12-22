#!/usr/bin/ruby -w

$:.unshift File.join(File.dirname(__FILE__), "lib")
require 'asiaip'

#asiaip = AsiaIP.new
asiaip = AsiaIP.new("http://ftp.apnic.net/stats/apnic/delegated-apnic-latest")
asiaip.cidr_each("IN") do |cidr|
  puts cidr
end
