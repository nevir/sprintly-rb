# Person
# ======
class Sprintly::Person
  include Sprintly::Model

  def self.payload_identity(payload)
    payload["id"]
  end

  # Attributes
  # ----------
  attribute :id,         read_only: true
  attribute :first_name, read_only: true
  attribute :last_name,  read_only: true
  attribute :email,      read_only: true
  attribute :admin?,     read_only: true

  def name
    [self.first_name, self.last_name].compact.join(" ")
  end

end
