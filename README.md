# Society

Society analyzes and presents a social graph of relationships between classes in a Ruby or Rails project.

Please note that Society requires Ruby 2.1 or later.

## Sample output

### Network graph

![Network graph][network]

### Heatmap

![Heatmap][heatmap]

## Installation

Add this line to your application's Gemfile:

    gem 'society'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install society

## Usage

From your terminal:

    society from path/to/models

and then open `doc/society/index.htm` in your browser.

For more complex applications, society also supports file globbing:

    society from ../path/to/models/*user*

The default format is HTML; you can skip the HTML interface and just get the
JSON by passing `--format json`

Note that all JSON data is timestamped (regardless of output format) to store
snapshots of your project over time.

## Recognition

Society was inspired by an original idea by Kerri Miller (@kerrizor).

## Contributing

Please note that this project is released with a [Contributor Code of Conduct]
(http://contributor-covenant.org/version/1/0/0/).
By participating in this project you agree to abide by its terms.


1. Fork it ( https://github.com/CoralineAda/society/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[network]: https://raw.githubusercontent.com/CoralineAda/society/master/network_graph.png "Sample network graph"
[heatmap]: https://raw.githubusercontent.com/CoralineAda/society/master/heatmap.png "Sample heatmap"
