class Sprintly::Annotation
  include Sprintly::Model

  def self.payload_identity(payload)
    # Note that the API layer synthesizes `product_id` and `item_number`.
    # The `sprint.ly` endpoint does not emit either.
    [payload["product_id"], payload["item_number"], payload["id"]]
  end

  # Attributes
  # ----------
  attribute :verb,          read_only: true
  attribute :action,        read_only: true
  attribute :body,          read_only: true
  attribute :user, :Person, read_only: true

end
