
class Network
  def initialize(network, prefix)
    @network = network
    @prefix = prefix
  end
  def cidr
    "#{@network}/#{@prefix}"
  end
end

class IPS
  attr_reader :mask_octet
  def initialize(country, start, value)
    @country = country
    @start = start
    @value = value.to_i
    @elems = start.split('.').map{|elem| elem.to_i}
    @mask_octet = nil

    if @value < 256
      raise "out of range"
    elsif @value < 256**2
      @mask_octet = 1
    elsif @value < 256**3
      @mask_octet = 2
    elsif @value < 256**4
      @mask_octet = 3
    else
      raise "out of range"
    end
  end
  def prefix
    32 - 8*@mask_octet
  end
  def IPS.cidr(*octets)
    raise "wrong number of octets" if octets.size != 4
    octets.each do |octet|
      raise "out of range: octet is larger than 255" if octet > 255
    end
    octets.join(".")
  end
  def IPS.cidr_calc(start, value, in_prefix)
    elems = start.split('.').map{|elem| elem.to_i}
    if in_prefix == 24
      elems[2] += value
    elsif in_prefix == 16
      elems[1] += value
    elsif in_prefix == 8
      elems[0] += value
    else
        raise "Unknown prefix: #{in_prefix}"
    end
    IPS.cidr(*elems)
  end
  def to_cidr_list
    ips = []
    0.upto(@value/(256**@mask_octet)-1){|i|
      base = IPS.cidr_calc(@start,i ,prefix)
      network = Network.new(base, prefix)
      ips << "#{@country} #{network.cidr}"
    }
    ips
  end
end

class AsiaIP
  def initialize
    @file = "delegated-apnic-latest"
    @ips = []
  end
  def cidr_each(search_country=nil)
    open(@file).each{|line|
      next if line =~ /^#/
      elems = line.split('|')
      country, type, start, value = elems.values_at(1,2,3,4)
      next if type != 'ipv4' || start == '*'
      next if search_country && country != search_country

      @ips << IPS.new(country, start, value)
    }
    @ips.each do |ip|
      ip.to_cidr_list.each do |cidr|
        yield cidr
      end
    end
  end
end
