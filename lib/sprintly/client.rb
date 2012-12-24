# Sprintly::Client
# ================
require "faraday"
require "faraday_middleware"

class Sprintly::Client
  extend  Sprintly::AutoloadConvention
  include Sprintly::Client::IdentityMap

  def initialize(account_email, api_token, options={})
    @options = {
      # The base URL used to make requests
      endpoint: "https://sprint.ly/api",
    }.merge(options)

    @connection = Faraday.new(url: @options[:endpoint]) do |faraday|
      # The API also expects form-encoded params when `POST`ing.
      faraday.request :url_encoded
      # [Sprint.ly only supports basic auth for now](http://help.sprint.ly/knowledgebase/articles/98353-authentication)
      faraday.request :basic_auth, account_email, api_token

      faraday.response :json

      # This seems like it should be a default for `faraday`; ah well.
      faraday.adapter Faraday.default_adapter
    end
  end

  # The configured options for this client
  attr_reader :options

  # We expose the `faraday` object for additional customization, should you
  # require it.
  attr_reader :connection

  # Raw API access
  def api
    @api ||= Sprintly::API.new(self)
  end


  # API Calls
  # ---------

  # All products the current user has access to
  def products
    self.api.get_products.map { |p| model(:Product, p) }
  end

  def create_product(name)
    model(:Product, self.api.create_product(name))
  end


  # Request Helpers
  # ---------------

  # Make a request (relative to `options[:endpoint]`)
  def request(method, path, params=nil)
    response = self.connection.send(method, "#{path}.json", params)

    # Success!
    if response.status >= 200 && response.status < 300
      return response.body
    else
      raise Sprintly::Error.from_response(response)
    end
  end

  def get(path, params=nil)
    self.request(:get, path, params)
  end

  def post(path, params=nil)
    self.request(:post, path, params)
  end

  def delete(path, params=nil)
    self.request(:delete, path, params)
  end

end
