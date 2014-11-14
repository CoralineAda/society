require "thor"
require "society"

module Society

  class CLI < Thor

    desc_text = ""

    desc "from PATH_TO_FILE", desc_text
    def from(path="./")
      parser = Society::Parser.new(path)
      graph = parser.class_graph
      heatmap_json = parser.formatters(graph).heatmap.to_json
      network_json = parser.formatters(graph).network.to_json
      file = File.open("./doc/data/heatmap.json","w"); file.write heatmap_json; file.close
      file = File.open("./doc/data/network.json","w"); file.write network_json; file.close
      puts "Done."
    end

    default_task :from

    private

    def formatter
      Formatters::Text
    end

  end

end