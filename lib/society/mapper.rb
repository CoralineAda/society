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
    @rotation ||= 360 / ordinals.count.to_f
  end

  def ordinals
    %w{one two three four five six seven eight nine ten eleven twelve}
  end

  def content
#    @content ||= self.graph.nodes[0..24].each_with_index.map do |node, index|
    @content ||= ordinals.each_with_index.map do |node, index|
      x = Math.sin(index) * 10
      %Q{<text font-family="Verdana" font-size="10" x="#{x}" y="300" text-anchor="#{x > 0 ? 'end' : 'start'}" transform="rotate(#{rotation * index} 200,300)" fill="black">#{node}</text>}
    end
  end

  def document
    %Q{<?xml version="1.0" standalone="no"?>
        <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
        <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
        #{content.join("\n")}
        </svg>
    }
  end

end