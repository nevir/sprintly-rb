module Sprintly::Client::IdentityMap

  def model_class(model_name)
    Sprintly.const_get(model_name)
  end

  # Builds or retrieves/updates a given model
  def model(name_or_class, payload)
    if name_or_class.is_a? Class
      model_class = name_or_class
    else
      model_class = self.model_class(name_or_class)
    end

    begin
      identity = model_class.payload_identity(payload)
      raise "identity cannot be nil" if identity.nil?
    rescue
      raise "Failed to determine identity for #{model_class.inspect}: #{$!.message}\npayload: #{payload.inspect}"
    end

    @identity_map ||= {}
    @identity_map[model_class] ||= {}

    if @identity_map[model_class][identity]
      @identity_map[model_class][identity].unpack! payload
    else
      @identity_map[model_class][identity] = model_class.new(payload, self)
    end

    @identity_map[model_class][identity]
  end

  def clear_identity_map!
    @identity_map = {}
  end

end
