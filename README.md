# Evaporator

![evaporation](http://keysigndictionary.wikispaces.com/file/view/evaporation.png/170345429/320x235/evaporation.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'evaporator', github: 'pivotal/evaporator'
```

And then execute:

    $ bundle

## Features
* Deploys Rails apps to Cloud Foundry with a simple rake task.
* Checks that you have no uncommitted changes before deploying.
* Checks that your ENV are consistent from one deploy to the next.
* Adds the GIT SHA of the deployed commit to the app's ENV variables.


## Usage

### Assumptions
Evaporator assumes that your app has two instances: staging and production. It assumes
that the manifest for the staging version of the app is located at `config/cf-staging.yml` and
assumes that the production version of the app has a manifest located at `config/cf-production.yml`.


Example Manifest File.

```
# config/cf-staging.yml

---
applications:
- name: <your-cf-appname>
  command: bundle exec rake db:migrate && bundle exec rails s -p $PORT

```

Evaporator assumes that you have already logged into Cloud Foundry via `cf-cli`.
 [Cloud Foundry CLI (cf-cli) Documentation](https://github.com/cloudfoundry/cli)



### Deploy to Staging

    $ rake SPACE=<your-cf-space> cf:deploy:staging

### Deploy to Production

    $ rake SPACE=<your-cf-space> cf:deploy:production

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pivotal/evaporator.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
