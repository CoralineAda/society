require 'json'
require 'pry'

module Society

  module Formatter

    class Network

      include Society::Formatter::Core

      def to_json
        subject = "LiveCourse"
        nodes = self.nodes.select{|n| n.edges.about(subject).present? }
        nodes.map do |node|
          {
            name: node.name,
            edges: node.edges.about(subject).map{|e| e.to.full_name}
          }
        end.to_json
      end

    end

  end

end
