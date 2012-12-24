class Sprintly::Annotation
  include Sprintly::Model

  def self.payload_identity(payload)
    # Note that the API layer synthesizes `product_id` and `item_number`.
    # The `sprint.ly` endpoint does not emit either.
    [payload["product_id"], payload["item_number"], payload["id"]]
  end

  # Attributes
  # ----------
  attribute :verb
  attribute :action
  attribute :body
  attribute :user, :Person

end
