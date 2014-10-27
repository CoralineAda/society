require 'json'
require 'pry'

module Society

  module Matrix

    class EdgeBundling

      include Society::Matrix::Core

      def to_json
        [
          {
            name: "Fukuzatsu.Something.Foo",
            size: 3958,
            imports: ["Fukuzatsu.Something.Bar"]
          },
          {
            name: "Fukuzatsu.Bar",
            size: 3958,
            imports: ["Society.Something.Baz"]
          },
          {
            name: "Society.Baz",
            size: 3958,
            imports: ["Fukuzatsu.Something.Bar"]
          },
          {
            name: "Society.Bat",
            size: 3958,
            imports: ["Fukuzatsu.Something.Foo", "Fukuzatsu.Something.Bar"]
          }
        ].to_json
      end

    end

  end

end
