require 'docker_compose_env/version'
require 'open3'
require 'yaml'

# The main module for DockerComposeEnv, this provides a single "easy mode"
# method for setting up the environment.
module DockerComposeEnv
  def self.setup!(env: ENV, file: 'docker-compose.yml', process_env: {})
    config = YAML.safe_load(File.read(file))

    config.fetch('services', {}).keys.each do |service_name|
      (config['services'][service_name]['ports'] || []).each do |container_port|
        compose_port_info = nil

        if /(\d+)\/udp$/ =~ container_port
          parsed_port = /(?<port>\d+)\/udp$/.match(container_port).named_captures['port']

          command = "docker-compose --file=#{file} port --protocol=udp #{service_name} #{parsed_port}"
          Open3.popen3(process_env, command) do |stdin, stdout, stderr, wait_thr|
            compose_port_info = stdout.read
            wait_thr.value
          end

          if (compose_port_info =~ /^0\.0\.0\.0\:\d+\s*$/) == 0
            if env["#{service_name.upcase}_HOST"].nil?
              env["#{service_name.upcase}_HOST"] = '0.0.0.0'
            end

            if env["#{service_name.upcase}_PORT_#{parsed_port}_UDP"].nil?
              env["#{service_name.upcase}_PORT_#{parsed_port}_UDP"] = compose_port_info.gsub(/0\.0\.0\.0:(\d+)\s*/, '\1')
            end
          end
        else
          command = "docker-compose --file=#{file} port #{service_name} #{container_port}"
          Open3.popen3(process_env, command) do |stdin, stdout, stderr, wait_thr|
            compose_port_info = stdout.read
            wait_thr.value
          end

          if (compose_port_info =~ /^0\.0\.0\.0\:\d+\s*$/) == 0
            if env["#{service_name.upcase}_HOST"].nil?
              env["#{service_name.upcase}_HOST"] = '0.0.0.0'
            end

            if env["#{service_name.upcase}_PORT_#{container_port}"].nil?
              env["#{service_name.upcase}_PORT_#{container_port}"] = compose_port_info.gsub(/0\.0\.0\.0:(\d+)\s*/, '\1')
            end
          end
        end
      end
    end
  rescue Errno::ENOENT => exception
    raise exception unless exception.message == 'No such file or directory - docker-compose'
  end
end
