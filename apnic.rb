#!/usr/bin/ruby -w

$:.unshift File.join(File.dirname(__FILE__), "lib")
require 'asiaip'

apnic = AsiaIP.new
apnic.output
