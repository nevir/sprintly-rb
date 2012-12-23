module Common::Configuration
  class << self

    def credentials
      @credentials ||= begin
        require "yaml"
        # Contains a hash of environment -> credential mappings...
        hash = YAML.load_file File.expand_path("../../../.credentials.yaml", __FILE__)
        # Not pulling in AS or Hashie _just_ for this:
        Hash[hash.map { |key, value|
          [key.to_sym, Hash[ value.map { |k,v| [k.to_sym, v] } ]]
        }]

      rescue Errno::ENOENT
        # ...that looks something like this
        {
          test: {
            email: "fake@example.com",
            token: "15987e60950cf22655b9323bc1e281f9c4aff47e",
          }
        }
      end

    end

  end
end
