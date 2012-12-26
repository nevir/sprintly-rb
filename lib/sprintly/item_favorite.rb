class Sprintly::ItemFavorite
  include Sprintly::Model

  def self.payload_identity(payload)
    [payload["id"]]
  end

  # Attributes
  # ----------
  attribute :id,                  read_only: true
  attribute :user,       :Person, read_only: true
  attribute :created_at, :Time,   read_only: true

end
