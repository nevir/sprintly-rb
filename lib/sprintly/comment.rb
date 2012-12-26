class Sprintly::Comment
  include Sprintly::Model

  def self.payload_identity(payload)
    payload["id"]
  end

  # Attributes
  # ----------
  attribute :id, read_only: true

  attribute :body,                read_only: true
  attribute :type,                read_only: true
  attribute :created_by, :Person, read_only: true

end
