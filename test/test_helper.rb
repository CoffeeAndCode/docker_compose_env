$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'docker_compose_env'
require 'minitest/autorun'
require_relative 'support/docker_compose_helpers'
require_relative 'support/fixtures'

module MiniTest
  class Test
    include DockerComposeHelpers
    include Fixtures

    Fixtures.file_fixture_path = 'test/fixtures/files'
  end
end

Minitest.after_run do
  DockerComposeHelpers.cleanup
end
