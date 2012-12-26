module Fixtures; end
module Fixtures::Client; end
module Fixtures::Client::IdentityMap; end

class Fixtures::Client::IdentityMap::Disabled
  include Sprintly::Model

  def self.identity_mapping_disabled?
    true
  end

  attribute :name
  attribute :other

end
