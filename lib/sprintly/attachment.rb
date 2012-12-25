class Sprintly::Attachment
  include Sprintly::Model

  def self.payload_identity(payload)
    payload["id"]
  end

  # Attributes
  # ----------
  attribute :name
  attribute :href
  attribute :created_by, :Person
  attribute :created_at, :Time

end
