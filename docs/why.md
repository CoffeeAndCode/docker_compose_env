# Why Does This Exist?

I've repeatedly ran into configuration issues integrating Docker into my team's
development environment. While I love what containers can bring to bootstrapping
a project, I'm not sold on moving my development environment into a Docker
container. That means, niceities that I could depend on (like easy mapping to
other services) falls short and I end up having to map ports to developer host
machines. This creates problems when those ports are already in use and there
was no simple solution (that I found) to address simplifying configuration.


### The Problem

If you run your Ruby and/or Rails application outside of a Docker container,
you normally have to hardcode the port mapping to connect to services managed
by Docker Compose. For example, running a Rails application that connects with
a Postgres Docker container would include the following:

_.env_

```bash
POSTGRES_DB=app_db_name
POSTGRES_PASSWORD=password
POSTGRES_USER=postgres
```

_config/database.yml_

```yaml
development: &development
  adapter: postgresql
  database: <%= ENV['POSTGRES_DB'] %>_dev
  encoding: unicode
  host: 127.0.0.1
  password: <%= ENV['POSTGRES_PASSWORD'] %>
  pool: 5
  port: 5432
  username: <%= ENV['POSTGRES_USER'] %>

test:
  <<: *development
  database: <%= ENV['POSTGRES_DB'] %>_test
```

_docker-compose.yml_

```yaml
version: '3.3'

services:
  postgres:
    image: postgres:9.6-alpine
    env_file: .env
    ports:
      - "5432:5432"
```

The good part is that this works just fine. However there are a few situations
where things start to fall down.

If you want to run your application on a machine that already has something
listening on that port, Docker Compose will be unable to map the port properly
(since it's already in use). That means if anyone has `mysql` or `postgres`
installed through Homebrew, there will need to be additional notes for them
to know how to work with your application.

If you happen to work on multiple Rails applications at the same time, you may
run into multiple projects each competing for the same local port mappings.
Solutions such as hardcoding a different port to map to per project work, but
add to the cognative overhead of working with the project.


### The Solution

Instead of worrying about additional setup for your application, setup
Docker Compose to work with dynamic port assignments and inform your application
of the final ports to map to. This allows your configuration to look like this:

_.env_

```bash
POSTGRES_DB=app_db_name
POSTGRES_PASSWORD=password
POSTGRES_USER=postgres
```

_config/database.yml_

```yaml
development: &development
  adapter: postgresql
  database: <%= ENV['POSTGRES_DB'] %>_dev
  encoding: unicode
  host: <%= ENV['POSTGRES_HOST'] %> # dynamically setup by gem (probably 0.0.0.0)
  password: <%= ENV['POSTGRES_PASSWORD'] %>
  pool: 5
  port: <%= ENV['POSTGRES_PORT_5432'] %> # dynamically setup by gem
  username: <%= ENV['POSTGRES_USER'] %>

test:
  <<: *development
  database: <%= ENV['POSTGRES_DB'] %>_test
```

_docker-compose.yml_

```yaml
version: '3.3'

services:
  postgres:
    image: postgres:9.6-alpine
    env_file: .env
    ports:
      - "5432" # do not explicitly mention host port to map to
```
