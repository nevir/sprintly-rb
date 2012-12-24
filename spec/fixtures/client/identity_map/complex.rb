module Fixtures; end
module Fixtures::Client; end
module Fixtures::Client::IdentityMap; end

class Fixtures::Client::IdentityMap::Complex
  include Sprintly::Model

  def self.payload_identity(payload)
    [payload[:one], payload[:two]]
  end

  attribute :one
  attribute :two
  attribute :message

end
