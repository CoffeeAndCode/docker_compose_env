require 'open3'

module DockerComposeHelpers
  class << self
    attr_accessor :config_files
  end

  def self.cleanup
    # Shut down docker-compose daemons after tests are ran.
    print 'Stopping docker containers...', "\n"

    config_files.each do |config_file|
      DockerComposeHelpers.down(config_file)
    end
  end

  def self.down(config_file)
    command = "docker-compose --file=#{config_file} down --remove-orphans --volumes"
    output, status = Open3.capture2e(command)
    print output, "\n" unless status.success?
  end

  def self.up(config_file)
    command = "docker-compose --file=#{config_file} up --build --remove-orphans -d"
    output, status = Open3.capture2e(command)
    print output, "\n" unless status.success?
  end

  def with_docker_compose(config_file)
    DockerComposeHelpers.config_files = [] if DockerComposeHelpers.config_files.nil?
    unless DockerComposeHelpers.config_files.include?(config_file.to_s)
      DockerComposeHelpers.config_files << config_file
    end

    DockerComposeHelpers.up(config_file)
    yield(config_file, {})
  end
end
