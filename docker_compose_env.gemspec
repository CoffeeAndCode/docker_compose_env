# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'docker_compose_env/version'

Gem::Specification.new do |spec|
  spec.name = 'docker_compose_env'
  spec.version = DockerComposeEnv::VERSION
  spec.authors = ['Jonathan Knapp']
  spec.email = ['jon@coffeeandcode.com']

  # rubocop:disable LineLength
  spec.description = 'Simplify configuration between Docker Compose and Ruby/Rails apps in development.'
  # rubocop:enable LineLength
  spec.summary = spec.description
  spec.homepage = 'https://github.com/CoffeeAndCode/docker_compose_env'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(features|spec|test)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'minitest', '~> 5.10'
end
