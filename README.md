# Fukuzatsu

Fukuzatsu ("complexity") is a tool for measuring code complexity in Ruby class files. Its analysis is based on a cycomatic complexity algorithm.

You can learn more about cyclomatic complexity at http://en.wikipedia.org/wiki/Cyclomatic_complexity

Why should you care about this kind of complexity? More complex code tends to attract bugs and to increase the friction around extending features or refactoring code.

Fukuzatsu was inspired by Saikuro, written by Zev Blut.

## Installation

Install the gem:

    $ gem install fukuzatsu

This installs the CLI tool.

## Usage

    fuku parse path/to/file/my_file.rb

    fuku parse path/to/file/my_file.rb -f html
    # Writes to doc/fuzuzatsu/path/to_file/my_file.rb.htm

    fuku parse path/to/file/my_file.rb -f csv
    # Writes to doc/fuzuzatsu/path/to_file/my_file.rb.csv

## Contributing

Please note that this project is released with a [Contributor Code of Conduct](https://gitlab.com/coraline/fukuzatsu/blob/master/CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
