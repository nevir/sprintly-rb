# Touching any of these files should cause the entire test suite to reload.
GLOBAL_SPEC_FILES = [
  ".rspec",
  %r{^spec/.*_helper\.rb$},
  %r{^spec/common/.*\.rb$},
  "lib/sprintly.rb",
  "lib/sprintly/api.rb",
  "lib/sprintly/autoload_convention.rb",
]

guard "bundler" do
  watch("Gemfile")
  watch(/^.+\.gemspec/)
end

guard "spork", rspec_port: 2731 do
  watch("Gemfile")
  watch("Gemfile.lock")

  GLOBAL_SPEC_FILES.each do |pattern|
    watch(pattern) { :rspec }
  end
end

guard "rspec", cli: '--drb --drb-port 2731' do
  GLOBAL_SPEC_FILES.each do |pattern|
    watch(pattern) { "spec" }
  end

  watch(%r{^spec/.+_spec\.rb$})

  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/fixtures/(.+)/[^/]+$}) { |m| "spec/sprintly/#{m[1]}_spec.rb" }
end
