
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
  def output
    ips = []
    if @value < 256**2
      0.upto(@value/256-1){|i|
        base = IPS.cidr(@elems[0],@elems[1],@elems[2]+i,@elems[3])
        network = Network.new(base, prefix)
        ips << "#{@country} #{network.cidr}"
      }
    elsif @value < 256**3
      0.upto(@value/(256**2)-1){|i|
        base = IPS.cidr(@elems[0],@elems[1]+i,@elems[2],@elems[3])
        network = Network.new(base, prefix)
        ips << "#{@country} #{network.cidr}" 
      }
    end
    ips
  end
end

class APNIC
  def initialize(country_code)
    @file = "delegated-apnic-latest"
    @ips = []
    
    open(@file).each{|line|
      if line =~ /\|#{country_code}\|ipv4/
        elems = line.split('|')
        country, start, value = elems.values_at(1,3,4)
        @ips << IPS.new(country, start, value)
      end
    }
  end
  def output
    @ips.each do |ip|
      puts ip.output
    end
  end
end
