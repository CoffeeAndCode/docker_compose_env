require 'docker_compose_env'
require 'rails'

module DockerComposeEnv
  # Setup DockerComposeEnv before Rails initializers.
  class Railtie < Rails::Railtie
    config.before_configuration { DockerComposeEnv.setup! }
  end
end
