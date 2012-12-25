class Sprintly::ItemBlock
  include Sprintly::Model

  def self.payload_identity(payload)
    [payload["id"]]
  end

  # Attributes
  # ----------
  attribute :id

  # `item` blocks `user` from completing `blocked`
  attribute :item,    :Item
  attribute :blocked, :Item
  attribute :user,    :Person

end
