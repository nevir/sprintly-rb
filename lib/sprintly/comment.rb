class Sprintly::Comment
  include Sprintly::Model

  def self.payload_identity(payload)
    payload["id"]
  end

  # Attributes
  # ----------
  attribute :id

  attribute :body
  attribute :type
  attribute :created_by, :Person

end
