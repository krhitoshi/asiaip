
#$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require './asiaip.rb'
require 'test/unit'

class TestIPS < Test::Unit::TestCase
  def setup
  end
  def test_cidr
    assert_equal("192.168.0.1", IPS.cidr(192, 168, 0, 1))
  end
end

class TestAsiaIP < Test::Unit::TestCase
  def setup
    @ip = APNIC.new("IN")
  end
end
