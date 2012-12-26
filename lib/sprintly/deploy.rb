class Sprintly::Deploy
  include Sprintly::Model

  def self.identity_mapping_disabled?
    true
  end


  # Attributes
  # ----------
  attribute :environment,         read_only: true
  attribute :version,             read_only: true
  attribute :notes,               read_only: true
  attribute :user,  :Person,      read_only: true
  attribute :items, Array[:Item], read_only: true

end
