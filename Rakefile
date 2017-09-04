require 'bundler/gem_helper'
require 'rake/testtask'

namespace 'docker_compose_env' do
  Bundler::GemHelper.install_tasks name: 'docker_compose_env'
end

namespace 'docker_compose_env_rails' do
  Bundler::GemHelper.install_tasks name: 'docker_compose_env_rails'
end

task build: ['docker_compose_env:build', 'docker_compose_env_rails:build']
task install: ['docker_compose_env:install', 'docker_compose_env_rails:install']
task release: ['docker_compose_env:release', 'docker_compose_env_rails:release']

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task default: :test
