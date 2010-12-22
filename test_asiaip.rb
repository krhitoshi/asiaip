
#$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require './asiaip.rb'
require 'test/unit'

class TestNetwork < Test::Unit::TestCase
  def test_cidr
    assert_equal("192.168.0.0/24", Network.new("192.168.0.0",24).cidr)
  end
end

class TestIPS < Test::Unit::TestCase
  def setup
  end
  def test_raise
    assert_raise(RuntimeError){IPS.new("IN","192.168.0.0", "10")}
    assert_raise(RuntimeError){IPS.new("IN","192.168.0.0", "16777216")}
  end
  def test_prefix
    assert_equal(24, IPS.new("IN","192.168.0.0", "256").prefix)
    assert_equal(16, IPS.new("CN","192.168.0.0", "65536").prefix)
    assert_equal(16, IPS.new("CN","192.168.0.0", "131072").prefix)
  end
  def test_mask_octet
    assert_equal(1, IPS.new("IN","192.168.0.0", "256").mask_octet)
  end
  def test_ips
    assert_equal(["IN 192.168.0.0/24"],
                 IPS.new("IN","192.168.0.0", "256").output)
    assert_equal(["CN 192.168.0.0/24","CN 192.168.1.0/24"],
                 IPS.new("CN","192.168.0.0", "512").output)
    assert_equal(["JP 192.168.0.0/16","JP 192.169.0.0/16"],
                 IPS.new("JP","192.168.0.0", "131072").output)
  end
  def test_cidr
    values = [[[192, 168, 0, 0],"192.168.0.0"],
              [[172, 16, 100, 255],"172.16.100.255"]]

    values.each do |input, res|
      assert_equal(res, IPS.cidr(*input))
    end
  end
  def test_cidr_calc
    assert_equal("192.168.1.0",IPS.cidr_calc("192.168.0.0",1,24))
    assert_equal("192.168.255.0",IPS.cidr_calc("192.168.0.0",255,24))
    assert_equal("192.169.0.0",IPS.cidr_calc("192.168.0.0",1,16))
    assert_equal("192.255.0.0",IPS.cidr_calc("192.168.0.0",87,16))

    assert_raise(RuntimeError){ IPS.cidr_calc("192.168.0.0",256,24) }
    assert_raise(RuntimeError){ IPS.cidr_calc("192.168.0.0",88,16) }
  end
  def test_cidr_raise
    values = [[192, 168, 0, 256], [192, 168, 256, 0],
              [192, 256, 0, 1],   [256, 168, 0, 1],
              [192, 168, 0],      [192, 168, 0, 0, 1]]

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
