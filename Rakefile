# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'minitest/test_task'

Minitest::TestTask.create

require 'rubocop/rake_task'

RuboCop::RakeTask.new

desc 'Remove Gemfile.lock'
task :wipelock do
  system 'rm -f Gemfile.lock'
end

task default: %i[test rubocop wipelock]
