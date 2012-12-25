class Sprintly::ItemFavorite
  include Sprintly::Model

  def self.payload_identity(payload)
    [payload["id"]]
  end

  # Attributes
  # ----------
  attribute :id
  attribute :user,       :Person
  attribute :created_at, :Time

end
