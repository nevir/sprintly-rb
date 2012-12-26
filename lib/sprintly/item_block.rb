class Sprintly::ItemBlock
  include Sprintly::Model

  def self.payload_identity(payload)
    [payload["id"]]
  end

  # Attributes
  # ----------
  attribute :id, read_only: true

  # `item` blocks `user` from completing `blocked`
  attribute :item,    :Item,   read_only: true
  attribute :blocked, :Item,   read_only: true
  attribute :user,    :Person, read_only: true

end
