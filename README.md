# Evaporator

<insert funny image>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'evaporator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install evaporator

## Usage

### Assumptions
Evaporator assumes that your app has two instances: staging and production. It assumes
that the manifest for the staging version of the app is located at `config/cf-staging.yml` and
assumes that the production version of the app has a manifest located at `config/cf-production.yml`.

### Deploy to Staging

    $ rake SPACE=yourspace cf:deploy:staging

### Deploy to Production

    $ rake SPACE=yourspace cf:deploy:production

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pivotal/evaporator.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
