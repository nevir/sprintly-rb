class Sprintly::Error < StandardError
  extend Sprintly::AutoloadConvention

  STATUS_MAPPING = {
    410 => :Archived,
  }

  # Most errors are just a wrapper around HTTP status codes and whatever
  # response we got back from `sprint.ly`.
  def initialize(message, status=nil)
    @status = status

    super(message)
  end

  attr_reader :status

  def to_s
    result  = super
    result += " (HTTP status #{@status})" if @status

    result
  end


  class << self

    def from_response(response)
      if error_class_name = STATUS_MAPPING[response.status]
        error_class = self.const_get(error_class_name)
      else
        error_class = self
      end

      error_class.new(response.body["message"], response.status)
    end

  end

end
