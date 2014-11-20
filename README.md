# Society

Society analyzes and presents a social graph of relationships between classes or
methods.

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

and then open `doc/index.htm` in your browser.

The default format is HTML; you can skip the HTML interface and just get the
JSON by passing `--format json`

Note that all JSON data is timestamped (regardless of output format) to store
snapshots of your project over time.

## TODO

* Hierarchical edge bundling visualization (e.g. http://bl.ocks.org/mbostock/7607999)

## Updating assets

Run `bower install` from the command line to install updated javascript and
CSS files, maintained in their separate repo.

## Contributing

Please note that this project is released with a [Contributor Code of Conduct]
(http://contributor-covenant.org/version/1/0/0/).
By participating in this project you agree to abide by its terms.


1. Fork it ( https://github.com/[my-github-username]/society/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
