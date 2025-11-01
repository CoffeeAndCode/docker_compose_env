# coding: utf-8

Gem::Specification.new do |spec|
  spec.name = 'docker_compose_env_rails'
  spec.version = '1.0.0'
  spec.authors = ['Jonathan Knapp']
  spec.email = ['jon@coffeeandcode.com']

  spec.description = 'Automate docker_compose_env in Rails.'
  spec.summary = spec.description
  spec.homepage = 'https://github.com/CoffeeAndCode/docker_compose_env'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(features|spec|test)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'docker_compose_env', '1.0.0'
  spec.add_dependency 'railties'
end
