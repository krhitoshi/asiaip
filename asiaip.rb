
class IPS
  def initialize(start, value)
    @start = start
    @value = value.to_i
    @elems = start.split('.').map{|elem| elem.to_i}
  end
  def output
    text = ""
    if @value == 256
      text << "#{@start}/24\n" 
    elsif @value < 256*256
      0.upto(@value/256-1){|i|
        digit = @elems[2]+i
        puts "OUT #{digit}" if digit > 255
        base = [@elems[0],@elems[1],@elems[2]+i,@elems[3]].join('.')
        text << "#{base}/24 #{@value} +#{i}\n" 
      }
    elsif @value < 256*256*256
      0.upto(@value/(256*256)-1){|i|
        base = [@elems[0],@elems[1]+i,@elems[2],@elems[3]].join('.')
        text << "#{base}/16 #{@value} +#{i}\n" 
      }
    elsif @value < 256*256*256
      test << ""
    end
    text
  end
end

class APNIC
  def initialize(country_code)
    @file = "delegated-apnic-latest"
    @ips = []
    
    open(@file).each{|line|
      if line =~ /\|#{country_code}\|ipv4/
        elems = line.split('|')
        start, value = elems[3..4]
        @ips << IPS.new(start, value)
      end
    }
  end
  def output
    @ips.each do |ip|
      puts ip.output
    end
  end
end

apnic = APNIC.new("IN")
apnic.output
