require 'thor'

class Fuku < Thor

  desc "parse", "parse a file"
  def parse(file)
    puts "I got this file: #{file}"
  end

end