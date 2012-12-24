class Sprintly::Annotation
  include Sprintly::Model

  def self.payload_identity(payload)
    # TODO: `id` does not appear to be unique across all projects by the user?
    [payload["id"]]
  end

  # Attributes
  # ----------
  attribute :verb
  attribute :action
  attribute :body
  attribute :user, :Person

end
