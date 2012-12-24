module Fixtures; end
module Fixtures::Client; end
module Fixtures::Client::IdentityMap; end

class Fixtures::Client::IdentityMap::Simple
  include Sprintly::Model

  def self.payload_identity(payload)
    payload[:id]
  end

  attribute :id
  attribute :name
  attribute :other

end
