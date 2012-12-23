# Sprintly::Client
# ================
require "faraday"
require "faraday_middleware"

class Sprintly::Client

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
    self.api.get_products.map { |p| Sprintly::Product.new(p, self) }
  end

  def create_product(name)
    Sprintly::Product.new(self.api.create_product(name), self)
  end


  # Request Helpers
  # ---------------

  # Retrieve a resource by URL (relative to `options[:endpoint]`)
  def get(path, params={})
    @connection.get("#{path}.json", params).body
  end

  # Modify/create a resource by URL (relative to `options[:endpoint]`)
  def post(path, params={})
    @connection.post("#{path}.json", params).body
  end

  # Delete a resource by URL
  def delete(path, params={})
    @connection.delete("#{path}.json", params).body
  end

end
