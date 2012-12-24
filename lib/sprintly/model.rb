# Model
# =====
require "time"

module Sprintly::Model

  # Model Methods
  # -------------
  def initialize(payload, client)
    self.unpack! payload

    @client = client
  end

  def unpack!(payload)
    payload.each do |key, value|
      value = Sprintly::Model.unpack_value(value)
      self.instance_variable_set(:"@#{key}", value)
    end
  end


  # Model DSL
  # ---------
  def self.included(target)
    target.extend ClassMethods
  end

  module ClassMethods

    def attribute(name, options={})
      ivar_name = name.to_s.gsub(/\?$/, '')

      class_eval <<-end_eval, __FILE__, __LINE__
        def #{name}
          @#{ivar_name}
        end
      end_eval

      unless options[:read_only]
        class_eval <<-end_eval, __FILE__, __LINE__
          def #{ivar_name}=(new_value)
            @#{ivar_name} = new_value
          end
        end_eval
      end
    end

  end


  # Utility
  # -------
  class << self

    # We expect a pretty static format; not going to go overboard.
    #
    # `2012-12-18T08:13:44+00:00`
    ISO8601 = /^\d{4}-\d{1,2}-\d{1,2}T\d{1,2}:\d{1,2}:\d{1,2}(Z|[+\-]\d{1,2}:\d{1,2})$/

    def unpack_value(value)
      if value.is_a?(String) && value =~ ISO8601
        return Time.parse(value)
      end

      value
    end

  end

end
