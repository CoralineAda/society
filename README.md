# Fukuzatsu

*Note: this gem is a work in progress and should not be considered production-ready until version 1.0*

Fukuzatsu ("complexity") is a tool for measuring code complexity in Ruby class files. Its analysis
generates relative complexity figures similar to the results of cyclomatic complexity algorithms. 
(You can learn more about cyclomatic complexity at http://en.wikipedia.org/wiki/Cyclomatic_complexity)

Why should you care about this kind of complexity? More complex code tends to attract bugs and to 
increase the friction around extending features or refactoring code.

Fukuzatsu was created by Coraline Ada Ehmke with invaluable assistance from Mike Ziwisky (mziwisky). 
It was inspired by Saikuro, written by Zev Blut.

## Screenshots

These are screenshots of the `-f html` output. First, the overall project summary:

![Project Summary](https://gitlab.com/coraline/fukuzatsu/raw/master/doc/overview.png)

Then the detail view of a single class:

![Project Summary](https://gitlab.com/coraline/fukuzatsu/raw/master/doc/details.png)

## Installation

Install the gem:

    $ gem install fukuzatsu

This installs the CLI tool.

## Usage

    fuku check path/to/file/my_file.rb

    fuku check path/to/file/my_file.rb -f html
    # Writes to doc/fuzuzatsu/path/to_file/my_file.rb.htm

    fuku check path/to/file/my_file.rb -f csv
    # Writes to doc/fuzuzatsu/path/to_file/my_file.rb.csv

## Contributing

Please note that this project is released with a [Contributor Code of Conduct](https://gitlab.com/coraline/fukuzatsu/blob/master/CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request