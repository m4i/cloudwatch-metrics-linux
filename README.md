# CloudWatchMetrics::Linux

Send meminfo and loadavg to CloudWatch Metrics

[![Gem Version](https://badge.fury.io/rb/cloudwatch-metrics-linux.svg)](https://badge.fury.io/rb/cloudwatch-metrics-linux)
[![Code Climate](https://codeclimate.com/github/m4i/cloudwatch-metrics-linux/badges/gpa.svg)](https://codeclimate.com/github/m4i/cloudwatch-metrics-linux)
[![Dependency Status](https://gemnasium.com/badges/github.com/m4i/cloudwatch-metrics-linux.svg)](https://gemnasium.com/github.com/m4i/cloudwatch-metrics-linux)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cloudwatch-metrics-linux'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cloudwatch-metrics-linux

Or use Docker:

    $ docker run --rm m4i0/cloudwatch-metrics-linux --help

## Usage

```
Usage: cloudwatch-metrics-linux [options]
        --namespace <namespace>
        --dimensions <name1=value1,name2=value2,...>
        --[no-]memory-used
        --[no-]memory-utilization
        --[no-]swap-used
        --[no-]swap-utilization
        --[no-]load-average-1min
        --[no-]load-average-5min
        --[no-]load-average-15min
        --interval <seconds>
        --dry-run
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/m4i/cloudwatch-metrics-linux. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
