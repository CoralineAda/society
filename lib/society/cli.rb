require "thor"
require "society"

module Society

  class CLI < Thor

    desc_text = ""
    desc "from PATH_TO_FILE", desc_text
    def from(path="./",scope=nil)
      parser = Society::Parser.new(path, scope)
      File.open("./doc/data/heatmap.json","w") do |file|
        file.write parser.formatters(parser.class_graph).heatmap.to_json
      end
      File.open("./doc/data/network.json","w") do |file|
        file.write parser.formatters(parser.class_graph).network.to_json
      end
      puts "Done."
    end

    default_task :from

  end

end