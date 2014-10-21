module Society
  class Mapper

    attr_reader :graph

    LINE_HEIGHT = 10

    def initialize(graph)
      @graph = graph
    end

    def write
      File.open(path_to_file, "w"){ |file| file.puts document }
    end

    private

    def path_to_file
      "./graph.svg"
    end

    def rotation
      @rotation ||= 360 / sorted_node_names.count.to_f
    end

    def sorted_node_names
      names = self.graph.nodes
      names = names.sort{|a,b| a.name.split('::').last.length <=> b.name.split('::').last.length}
      names = names.reject{|node| node.references.empty?}
      names.compact
    end

    def content
      @content ||= sorted_node_names.each_with_index.map do |node, index|
        name = node.name.split("::").last
        rotate = "#{rotation * index} 500,500)"
        %Q{
          <text font-family="Verdana" font-size="10" x="100" y="500" text-anchor="end" transform="rotate(#{rotate}">
            <title>#{node.name}</title>
            #{name}
          </text>
        }
      end
    end

    def document
      %Q{<?xml version="1.0" standalone="no"?>
          <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
          <svg version="1.1" height="5000" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
          #{content.join("\n")}
          </svg>
      }
    end

  end
end