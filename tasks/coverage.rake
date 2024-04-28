# frozen_string_literal: true

CoverageError = Class.new(StandardError)
desc 'Run all specs with coverage'
task :coverage do
  ENV['COVERAGE'] = 'test'
  require 'json'
  require 'bigdecimal'
  coverage_file = Pathname('coverage/coverage.json')
  old_coverage = ''
  old_percent = 0
  if coverage_file.exist?
    old_coverage = coverage_file.read
    old_percent = BigDecimal(JSON.parse(old_coverage)['metrics']['covered_percent'], 4).to_f
  end

  sh 'ruby test/test_dapr.rb'

  new_coverage = coverage_file.read
  new_percent = BigDecimal(JSON.parse(new_coverage)['metrics']['covered_percent'], 4).to_f
  if new_percent < old_percent
    coverage_file.write old_coverage
    raise CoverageError, "Coverage dropped from #{old_percent}% to #{new_percent}%"
  elsif new_percent > old_percent
    puts "Coverage increased from #{old_percent}% to #{new_percent}%"
  else
    puts "Coverage stayed the same at #{old_percent}%"
  end
end
