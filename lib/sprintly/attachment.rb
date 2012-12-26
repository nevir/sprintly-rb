class Sprintly::Attachment
  include Sprintly::Model

  def self.payload_identity(payload)
    payload["id"]
  end

  # Attributes
  # ----------
  attribute :id,                  read_only: true
  attribute :name,                read_only: true
  attribute :href,                read_only: true
  attribute :created_by, :Person, read_only: true
  attribute :created_at, :Time,   read_only: true

end
