
#$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require './asiaip.rb'
require 'test/unit'

class TestIPS < Test::Unit::TestCase
  def setup
  end
  def test_ips
    assert_equal(["192.168.0.0/24"],IPS.new("192.168.0.0", "256").output)
    assert_equal(["192.168.0.0/24","192.168.1.0/24"],IPS.new("192.168.0.0", "512").output)
  end
  def test_cidr
    values = [[[192, 168, 0, 0],"192.168.0.0"],
              [[172, 16, 100, 255],"172.16.100.255"]]

    values.each do |input, res|
      assert_equal(res, IPS.cidr(*input))
    end
  end
  def test_cidr_raise
    values = [[192, 168, 0, 256], [192, 168, 256, 0],
              [192, 256, 0, 1], [256, 168, 0, 1],
              [192, 168, 0], [192, 168, 0, 0, 1],
             ]

    values.each do |input|
      assert_raise(RuntimeError){ IPS.cidr(*input) }
    end
  end
end

class TestAsiaIP < Test::Unit::TestCase
  def setup
    @ip = APNIC.new("IN")
  end
end
