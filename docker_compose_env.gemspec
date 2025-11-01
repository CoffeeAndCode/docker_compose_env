# coding: utf-8

Gem::Specification.new do |spec|
  spec.name = 'docker_compose_env'
  spec.version = '1.0.0'
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

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'minitest'
end
