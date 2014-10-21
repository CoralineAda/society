class Mapper

  attr_reader :graph

  LINE_HEIGHT = 10

  def initialize(graph)
    @graph = graph
  end

  def write
    File.open(path_to_file, "w") do |file|
      file.puts document
    end
  end

  private

  def path_to_file
    "./graph.svg"
  end

  def rotation
    @rotation ||= 360 / self.graph.nodes.count.to_f
  end

  def content
    @content ||= self.graph.nodes.map(&:name).sort{|a,b| a.length <=> b.length}.reverse.each_with_index.map do |node, index|
      name = node.split("::").last
      rotate = "#{rotation * index} 500,500)"
      %Q{
        <text font-family="Verdana" font-size="10" x="100" y="500" text-anchor="end" transform="rotate(#{rotate}">
          <title>#{node}</title>
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