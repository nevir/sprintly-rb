class Sprintly::Item
  include Sprintly::Model

  def self.payload_identity(payload)
    [payload["product"]["id"], payload["number"]]
  end

  # Attributes
  # ----------
  attribute :number, read_only: true
  attribute :title
  attribute :type

end
