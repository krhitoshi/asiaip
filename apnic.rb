#!/usr/bin/ruby -w

$:.unshift File.join(File.dirname(__FILE__), "lib")
require 'asiaip'

apnic = APNIC.new("IN")
apnic.output
