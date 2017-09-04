# DockerComposeEnv

Simplify configuration between Docker Compose and Ruby/Rails apps in development.

If you run Rails outside of Docker, this helps your application play be a better
first class citizen with your dev machine by utilizing dynamic port mapping in
Docker Compose services.

To read more about the problems this gem solves, check out the
[Why Does This Exist?](docs/why.md) documentation.

If your team is comfortable running Rails inside a container or you are looking
for a production solution for service discovery, this is _not_ what you want.


## Installation / Usage

In it's simpliest form, add this gem to your Rails app's Gemfile in the
development / test groups and specify the path to the Rails bootstrapper.

```ruby
group :development, :test do
  gem 'docker_compose_env_rails'
end
```

And then execute:

    $ bundle

- update database configuration
- show example docker-compose.yml file


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CoffeeAndCode/docker_compose_env.
