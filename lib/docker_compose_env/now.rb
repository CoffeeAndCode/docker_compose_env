# If you use gems that require environment variables to be set before they are
# loaded, then list `docker_compose_env` in the `Gemfile` before those
# other gems and require `docker_compose_env/now`.
#
#     gem 'docker_compose_env', require: 'docker_compose_env/now'
#     gem 'gem_that_requires_env_variables'
#

require 'docker_compose_env'
DockerComposeEnv.setup!
