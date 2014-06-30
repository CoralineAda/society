module Formatters

  module Base

    def content
      [
        header,
        rows,
        footer
      ].flatten.join("\r\n")
    end

    def write
      begin
        outfile{ |out| out.write(content) }
      rescue Exception => e
        puts e.error
        puts ebacktrace
      ensure
        outfile.close
      end
    end

    def outfile
      @outfile ||= File.open(filename, 'w')
    end

  end

end
