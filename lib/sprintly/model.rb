# Model
# =====
require "time"

module Sprintly::Model

  # Model Methods
  # -------------
  def initialize(payload, client)
    @_client = client

    self.unpack! payload
  end

  def client
    @_client
  end

  def unpack!(payload)
    payload.each do |key, value|
      self.unpack_value! key, value
    end
  end

  def unpack_value!(key, value)
    # Since we set ivars directly from payloads, make sure they don't stomp over
    # our private state by accident.
    return if key.to_s.start_with? "_"

    options = self.class.known_attributes[key.to_sym] || {}
    value   = Sprintly::Model.unpack_value(value, options[:type], self.client)

    self.instance_variable_set(:"@#{key}", value)
  end

  def attributes
    Hash[self.class.known_attributes.map { |name, options|
      [options[:ivar], self.send(name)]
    }]
  end


  # Model DSL
  # ---------
  def self.included(target)
    target.extend ClassMethods
  end

  module ClassMethods

    def known_attributes
      @known_attributes ||= {}
    end

    def attribute(name, *args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      options[:type] = args.pop if args.size > 0
      options[:ivar] = name.to_s.gsub(/\?$/, '').to_sym

      self.known_attributes[name] = options

      class_eval <<-end_eval, __FILE__, __LINE__
        def #{name}
          @#{options[:ivar]}
        end
      end_eval

      unless options[:read_only]
        class_eval <<-end_eval, __FILE__, __LINE__
          def #{options[:ivar]}=(new_value)
            self.unpack_value! :#{options[:ivar]}, new_value
          end
        end_eval
      end
    end

  end


  # Utility
  # -------
  class << self

    def model_namespace
      Sprintly
    end

    def model_class(name_or_class)
      return name_or_class if name_or_class.is_a? Class

      self.model_namespace.const_get(name_or_class, false)
    end

    def unpack_value(value, type, client)
      return value unless type
      return nil if value.nil?

      case type
      when :Symbol then return value.to_sym
      when :Time   then return Time.parse(value)
      end

      # We fall back to models if it's not an explicitly known type
      client.model(type, value)
    rescue Exception
      raise "Unknown/broken attribute type #{type.inspect}: #{$!}"
    end

  end

end
