require 'test_helper'

class DockerComposeEnvTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::DockerComposeEnv::VERSION
  end

  def test_module_has_a_setup_method
    assert_includes ::DockerComposeEnv.methods, :setup!
  end

  def test_will_raise_error_if_compose_file_not_found
    assert_raises(Errno::ENOENT) do
      ::DockerComposeEnv.setup!(env: {}, file: 'file-not-found.yml')
    end
  end

  def test_will_raise_error_if_passed_pathname_not_found
    assert_raises(Errno::ENOENT) do
      DockerComposeEnv.setup!(env: {}, file: Pathname.new('file-not-found.yml'))
    end
  end

  def test_will_not_raise_error_if_config_has_no_services
    config = file_fixture('docker_compose/no_services.yml')
    DockerComposeEnv.setup!(env: {}, file: config)
  rescue StandardError => error
    print error
    assert_equal '', error.message
  end

  def test_will_not_raise_error_if_docker_compose_not_found
    config = file_fixture('docker_compose/v3.3.yml')
    _, err = capture_io do
      DockerComposeEnv.setup!(env: {}, file: config, process_env: { 'PATH' => '' })
    end

    assert_equal "No such file or directory - docker-compose\n", err
  end

  def test_will_only_set_one_env_per_host_and_one_per_port
    config = file_fixture('docker_compose/v3.3.yml')
    with_docker_compose(config) do |config_file, env|
      DockerComposeEnv.setup!(env: env, file: config_file)

      assert_equal 7, env.keys.size
    end
  end

  def test_will_setup_passed_env_with_service_information
    config = file_fixture('docker_compose/v3.3.yml')
    with_docker_compose(config) do |config_file, env|
      DockerComposeEnv.setup!(env: env, file: config_file)

      assert_equal '0.0.0.0', env['CONVERTER_HOST']
      refute_nil env['CONVERTER_PORT_3000']
      refute_nil env['CONVERTER_PORT_6060_UDP']

      assert_equal '0.0.0.0', env['MYSQL_HOST']
      refute_nil env['MYSQL_PORT_3306']

      assert_equal '0.0.0.0', env['POSTGRES_HOST']
      refute_nil env['POSTGRES_PORT_5432']
    end
  end

  def test_will_set_service_env_host_on_udp_only_service
    config = file_fixture('docker_compose/udp_only_service.yml')
    with_docker_compose(config) do |config_file, env|
      DockerComposeEnv.setup!(env: env, file: config_file)

      assert_equal '0.0.0.0', env['POSTGRES_HOST']
      refute_nil env['POSTGRES_PORT_6060_UDP']
    end
  end

  def test_will_not_set_env_if_service_has_no_ports_listed
    config = file_fixture('docker_compose/no_ports.yml')
    with_docker_compose(config) do |config_file, env|
      DockerComposeEnv.setup!(env: env, file: config_file)

      assert_nil env['POSTGRES_HOST']
      assert_nil env['POSTGRES_PORT_6060_UDP']
    end
  end

  def test_will_not_override_existing_env_if_found
    config = file_fixture('docker_compose/v3.3.yml')
    with_docker_compose(config) do |config_file, env|
      env['POSTGRES_HOST'] = '1.1.1.1'
      env['POSTGRES_PORT_5432'] = '12345'
      DockerComposeEnv.setup!(env: env, file: config_file)

      assert_equal '1.1.1.1', env['POSTGRES_HOST']
      assert_equal '12345', env['POSTGRES_PORT_5432']
    end
  end
end
