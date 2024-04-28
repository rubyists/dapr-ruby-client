# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'minitest/test_task'

Minitest::TestTask.create

require 'rubocop/rake_task'

RuboCop::RakeTask.new

require 'pathname'
Pathname.glob('tasks/*.rake').each { |r| load r }

# Coverage and wipelock both come from tasks/
task default: %i[coverage rubocop wipelock]
