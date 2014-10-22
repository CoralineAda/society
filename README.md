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

     parser = Society::Parser.new(start_path: "path/to/models")

Generate an object dependency graph:

     graph = parser.class_graph

Generate a method dependency graph:

     graph = parser.method_graph

Generate JSON dependency matrix for export to d3:

    parser.matrix.to_jsno

## TODO

* Add fukuzatsu as a dependency

* Wrap fukuzatsu parsing and remove duplicate classes

## Contributing

Please note that this project is released with a [Contributor Code of Conduct](https://github.com/Bantik/society/blob/master/CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.


1. Fork it ( https://github.com/[my-github-username]/society/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
