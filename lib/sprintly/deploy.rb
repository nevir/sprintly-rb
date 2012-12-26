class Sprintly::Deploy
  include Sprintly::Model

  def self.identity_mapping_disabled?
    true
  end


  # Attributes
  # ----------
  attribute :environment
  attribute :version
  attribute :notes
  attribute :user,  :Person
  attribute :items, Array[:Item]

end
