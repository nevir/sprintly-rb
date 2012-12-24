#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec/core/rake_task"

# We want to force ourselves to review code coverage results.
task :default => :coverage

RSpec::Core::RakeTask.new(:spec) do |task|
  # No special configuration yet.
end

desc "Run the tests in CI mode"
task :ci do
  Rake::Task["spec"].execute
end

desc "Run tests with code coverage"
task :spec_with_coverage do
  prev = ENV["COVERAGE"]
  ENV["COVERAGE"] = "yes"

  Rake::Task["spec"].execute

  ENV["COVERAGE"] = prev
end

desc "Run tests with code coverage and open the results"
task :coverage => :spec_with_coverage do
  `open coverage/index.html`
end

desc "Run the tests in recording mode (GET requests only)"
task :record do
  ENV["RECORD_REQUESTS"] = "yes"

  Rake::Task["spec"].execute
end

namespace :record do
  desc "Run the tests in recording mode (all request types)"
  task :dangerously do
    ENV["DANGEROUS_RECORDING_ALLOWED"] = "yes"

    Rake::Task["record"].execute
  end
end

desc "Boot up an IRB console w/ sprintly preloaded"
task :console do
  require "sprintly"
  require "irb"

  # IRB parses ARGV on start; let's make it think that its in its own environment
  ARGV.clear
  IRB.start
end
