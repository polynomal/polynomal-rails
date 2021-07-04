# Polynomal for Rails

[Polynomal](https://www.polynomal.com) makes it easy for you to capture, query, and analyze your application metrics. Let us handle the metrics so you can focus on writing code.

## Description

The Polynomal gem aggregates and collects custom metrics in addition to metrics from multiple processes. Metrics are exported to Polynomal where they can be graphed, analyzed, and acted on.

## Installation

First, sign up for a Polynomal account and add the `polynomal-rails` gem to your Gemfile.

```ruby
# Gemfile
gem 'polynomal-rails'
```

Then run:

    $ bundle install

>  [TODO: Docs for API key config]

## Usage

### Process metrics

Polynomal automatically captures and collects all process metrics from your application. No additional config is needed here.

```ruby
# config/initializers/polynomal.rb

Polynomal.client.collect
```

### Custom metrics

If you want to capture and collect a custom metric you can add custom [...] anywhere in your code.

```ruby
# Simple increment
Polynomal.increment("users.sign_ups")

# Simple count
Polynomal.count("users.batch_delete_size", 200)

# Simple measure
Polynomal.measure("invoices.csv_generation_duration") do
  # ...
end
```

 Read more about custom metrics in our documentation.

## Development

### Installation

Make sure you have Bundler installed and then use the bin stub to install all possible dependencies.

```
# Install Bundler (optional)
$ gem install bundler

# Install the Polynomal gem via the bin stub
$ ./bin/setup
```

### Testing

`polynomal-rails` uses [Appraisals](https://github.com/thoughtbot/appraisal) for running specs. Appraisals enables us to test the gem against different versions of Rails. Currently we test against the following Rails versions: `5.2, 6.0, 6.1`.

Instead of running the standard `bundle exec rspec`, run:

```
$ bundle exec appraisal rspec
```

This will test the gem against all the Gemfiles under the `Gemfiles/` dir.

### Versioning

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jlholm/polynomal-rails.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
