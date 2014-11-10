# Fukuzatsu

Fukuzatsu ("complexity") is a tool for measuring code complexity in Ruby class files. Its analysis
generates scores based on cyclomatic complexity algorithms, which in simplest terms measure the number of execution paths through a given piece of code. (You can learn more about cyclomatic complexity [here](http://en.wikipedia.org/wiki/Cyclomatic_complexity).)

Why should you care about this kind of complexity? More complex code tends to attract bugs and to
increase the friction around extending features or refactoring code.

Fukuzatsu was created by [Coraline Ada Ehmke](http://where.coraline.codes/) and is maintained by [Coraline Ada Ehmke](http://where.coraline.codes/), [Mike Ziwisky](https://github.com/mziwisky), and the team at [Instructure](http://www.instructure.com/). It was originally inspired by Saikuro, written by Zev Blut.

## Screenshots

These are screenshots of the `-f html` output. First, the overall project summary:

![Project Summary](https://gitlab.com/coraline/fukuzatsu/raw/master/doc/images/overview.png)

Then the detail view of a single class:

![Project Summary](https://gitlab.com/coraline/fukuzatsu/raw/master/doc/images/details.png)

## Installation

Install the gem:

    $ gem install fukuzatsu

This installs the CLI tool.

## Usage

    fuku check path/to/file/my_file.rb

    fuku check path/to/file/my_file.rb -f html
    # Writes to doc/fuzuzatsu/htm/index.htm

    fuku check path/to/file/my_file.rb -f csv
    # Writes to doc/fuzuzatsu/csv/results.rb.csv

## Contributing

Please note that this project is released with a [Contributor Code of Conduct](https://gitlab.com/coraline/fukuzatsu/blob/master/CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request