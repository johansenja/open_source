# Open Source

Quickly open the source file of a Class, Module, or Method in your favourite editor, from Ruby.

## Usage

First make sure your EDITOR environment variable is set ([How do I find and set my $EDITOR environment variable?](https://askubuntu.com/questions/432524/how-do-i-find-and-set-my-editor-environment-variable)).

Then use as you wish

```ruby
# probably in a console, though doesn't have to be
open_source "User" # opens file where User class is defined
oso User           # same as above; use the aliases for ease of use!
oso Authenticable  # opens file where Authenticable module is defined
oso :log           # opens file where "log" method is defined
oso "log"          # same
oso method :log    # you get the idea
oso Rails.method(:application)
oso User.instance_method(:name)
```

Line numbers are supported too, currently for Vi and VsCode.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'open_source_location', require: "open_source"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install open_source_location

Just make sure you then `require 'open_source'` where you need it.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/johansenja/open_source.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
