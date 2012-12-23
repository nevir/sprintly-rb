require "rubygems"
require "spork"
require "spork/ext/ruby-debug"

Spork.prefork do
  # Allow requires relative to the spec dir
  SPEC_ROOT = File.expand_path("..", __FILE__)
  $LOAD_PATH << SPEC_ROOT

  require "time"
  require "rspec"
  require "webmock/rspec"

  # Eager-loaded dependencies
  require "faraday"

  # Load our spec environment (random to avoid dependency ordering)
  module Common; end
  Dir[File.join(SPEC_ROOT, "common", "*.rb")].shuffle.each do |helper|
    require "common/#{File.basename(helper, ".rb")}"
  end

  RSpec.configure do |config|
    config.treat_symbols_as_metadata_keys_with_true_values = true
  end
end

Spork.each_run do
  # The rspec test runner executes the specs in a separate process; plus it's nice to have this
  # generic flag for cases where you want coverage running with guard.
  if ENV["COVERAGE"]
    require "simplecov" # This executes .simplecov
  end

  # Must be loaded _after_ `simplecov`, otherwise it won't pick up on requires.
  require "sprintly"
end
