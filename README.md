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

For a Rails app, add this gem to your Gemfile in the development / test groups.

```ruby
group :development, :test do
  gem 'docker_compose_env_rails'
end
```

You will now have new `ENV` properties set from the `docker-compose.yml` file
in your project directory. The following compose config would assign
`ENV['DB_HOST']` and `ENV['DB_PORT_5432']` to the values returned
from running `docker-compose port db 5432`, the host and dynamically mapped
port assigned after you ran `docker-compose up`.

```yaml
version: '3.3'

services:
  db:
    image: postgres:9.6-alpine
    env_file: .env
    ports:
      - "5432"
```

That means your Rails `config/database.yml` file could look like:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  host: <%= ENV['DB_HOST'].to_i %>
  password: example
  pool: 5
  port: <%= ENV['DB_PORT_5432'].to_i %>
  username: postgres

development:
  <<: *default
  database: app

test:
  <<: *default
  database: app_test
```

### Load Faster!

If you need to load the dynamic port information faster than the
`before_configuration` call in `Railties`, you can add the `docker_compose_env`
gem higher up in the `Gemfile` and load it with a special require path:

```ruby
gem `docker_compose_env`, require: 'docker_compose_env/now'
```

### Further Customization

Unfortunately, there's only so much automagic that can be done. If you need to
customize the `docker-compose.yml` file name or location, or if you'd like to
collect the dynamic information somewhere besides `ENV`, you will need to
require the `docker_compose_env` gem and set it up yourself.

```ruby
# expects docker-compose.yml file and adds values to ENV
DockerComposeEnv.setup!

# customize docker-compose.yml path and adds values to ENV
DockerComposeEnv.setup!(file: 'docker/docker-compose.dev.yml')

# add dynamic values to custom object instead of ENV
config = {}
DockerComposeEnv.setup!(env: config)
puts config

# add dynamic values to custom object instead of ENV and custom compose path
config = {}
DockerComposeEnv.setup!(env: config, file: 'custom/path.yml')
puts config
```


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
