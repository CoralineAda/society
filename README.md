# Society

Society analyzes and presents a social graph of relationships between classes or methods.

## Installation

Add this line to your application's Gemfile:

    gem 'society'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install society

## Usage

Initialize a parser with source files:

     parser = Society::Parser.new("path/to/models")

Generate an object dependency graph:

     graph = parser.class_graph

Generate a method dependency graph:

     graph = parser.method_graph

Generate JSON dependency matrix for visualization:

    parser.matrix(parser.object_graph).to_json

  or

    parser.matrix(parser.method_graph).to_json

  then

    file = File.open("./doc/analysis.json","w"); file.write json; file.close

  and open `doc/index.htm` in your browser.

## TODO

* Hierarchical edge bundling visualization (e.g. http://bl.ocks.org/mbostock/7607999)

## Contributing

Please note that this project is released with a [Contributor Code of Conduct](https://github.com/Bantik/society/blob/master/CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.


1. Fork it ( https://github.com/[my-github-username]/society/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
