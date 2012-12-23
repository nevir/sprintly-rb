require "fileutils"
require "stringio"
require "zlib"

module Common::RequestFixtures
  ROOT = File.expand_path("../../fixtures/requests", __FILE__)

  module SpecDSL

    def with_fixture_set(set_name, &block)
      Common::RequestFixtures.set_stack.unshift set_name.to_sym

      block.call
    ensure
      Common::RequestFixtures.set_stack.shift
    end

    def with_dangerous_recording(&block)
      Common::RequestFixtures.allow_recording_of_dangerous_requests = true

      block.call
    ensure
      Common::RequestFixtures.allow_recording_of_dangerous_requests = false
    end

  end

  @record    = !!ENV["RECORD_REQUESTS"]
  @cache     = {}
  @set_stack = [:common]
  class << self

    attr_reader :set_stack

    attr_accessor :allow_recording_of_dangerous_requests

    def recording?
      @record
    end

    def fixture_path(request, set_name=self.set_stack.first)
      relative_path = request.uri.path.gsub(/^\/api\/(.*?)(\.json)?$/, "\\1")

      File.join(set_name.to_s, "#{relative_path.gsub("/", "-")}.#{request.method}.req")
    end

    def fixture(request)
      self.set_stack.map { |s| self.fixture_path(request, s) }.each do |path|
        return @cache[path] if @cache[path]
        # Don't bother hitting disk if we've already attempted a load -
        # signified by a `nil` in the cache.
        next if @cache.has_key? path

        file_path = File.join(ROOT, path)
        if File.exist? file_path
          return @cache[path] = open(file_path).read
        else
          @cache[path] = nil
        end
      end

      nil
    end

    def record_fixture(request, response)
      relative_path = self.fixture_path(request, self.set_stack.first)
      file_path     = File.join(ROOT, relative_path)

      self.clean_response! response
      response_data = self.response_data(response)

      # Save it
      FileUtils.mkpath(File.dirname(file_path))
      open(file_path, "w") do |file|
        file.write(response_data)
      end

      # And cache it
      @cache[relative_path] = response_data
    end

    def clean_response!(response)
      # Decompress gzipped responses for your sanity.
      if response.headers["Content-Encoding"] == "gzip"
        response.headers.delete("Content-Encoding")
        response.body = Zlib::GzipReader.new(StringIO.new(response.body)).read
      end
    end

    # HTTP Response format, except `\n` instead of `\r\n`.  Newline on the end
    # to be consistent about line endings.  We shouldn't be exploding if that's
    # there, regardless.
    def response_data(response)
      "".tap do |result|
        result << "HTTP/1.1 #{response.status.join(" ")}\n"
        response.headers.each do |key, values|
          Array(values).each do |value|
            result << "#{key}: #{value}\n"
          end
        end
        result << "\n"
        result << response.body
        result << "\n"
      end
    end

  end

end

if Common::RequestFixtures.recording?
  WebMock.disable_net_connect! allow: "sprint.ly"

  WebMock.after_request(real_requests_only: true) do |request, response|
    Common::RequestFixtures.record_fixture(request, response)
  end
end

RSpec.configure do |config|
  config.include Common::RequestFixtures::SpecDSL

  config.before(:each) do
    # We use a hash, indexed by object id, to track fixture lookups across the
    # two blocks in the stub.
    responses = {}
    WebMock.stub_request(:any, %r{sprint\.ly/api}).with { |request|
      # Success!  We have a fixture
      if fixture = Common::RequestFixtures.fixture(request)
        # Stick it in the tracking Hash
        responses[request.object_id] = fixture

      # If we are recording fixtures, we let some requests go through...
      elsif Common::RequestFixtures.recording?
        # ..but only if they are `GET` requests
        unless request.method == :get || Common::RequestFixtures.allow_recording_of_dangerous_requests
          fixture_path = Common::RequestFixtures.fixture_path(request)
          raise "Refusing to record non-GET request, and no fixture recorded at #{fixture_path}"
        end

      # No requests to go through if we aren't recording.
      else
        fixture_path = Common::RequestFixtures.fixture_path(request)
        raise "No fixture recorded at #{fixture_path}"
      end

    # Finally, return the fixture if we have one
    }.to_return(lambda { |request|
      responses.delete(request.object_id)
    })
  end
end
