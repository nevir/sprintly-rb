class Sprintly::Item
  include Sprintly::Model

  def self.payload_identity(payload)
    [payload["product"]["id"], payload["number"]]
  end

  # Attributes
  # ----------
  attribute :number
  attribute :title
  attribute :type

end
