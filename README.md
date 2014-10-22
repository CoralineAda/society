# Society

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'society'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install society

## Testing in IRB

     parser = Society::Parser.new(start_path: "path/to/models")
     graph = parser.object_graph
     Society::Mapper.new(graph).write

Then open `graph.svg` in your browser.

## Usage

TODO: Write usage instructions here

## Contributing

Please note that this project is released with a [Contributor Code of Conduct](https://github.com/Bantik/society/blob/master/CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.


1. Fork it ( https://github.com/[my-github-username]/society/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
