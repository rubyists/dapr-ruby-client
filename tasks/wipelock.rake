# frozen_string_literal: true

desc 'Remove Gemfile.lock'
task :wipelock do
  system 'rm -f Gemfile.lock'
end
