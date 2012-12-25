module Sprintly::Client::IdentityMap

  # Builds or retrieves/updates a given model
  def model(name_or_class, payload)
    model_class = Sprintly::Model.model_class(name_or_class)

    begin
      identity = Array(model_class.payload_identity(payload))
      if identity.size == 0 || identity.any?(&:nil?)
        raise "identity cannot be nil or contain nil components"
      end
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
