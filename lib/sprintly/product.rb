# Product
# =======
class Sprintly::Product
  include Sprintly::Model

  def self.payload_identity(payload)
    payload["id"]
  end

  # Attributes
  # ----------
  attribute :id,                read_only: true
  attribute :created_at, :Time, read_only: true
  attribute :name
  attribute :archived?
  attribute :admin?

  # The email address for a particular task type.
  #
  # See [the support documentation](http://help.sprint.ly/knowledgebase/articles/102435-creating-new-bugs-tasks-and-tests-via-email-)
  # for more information.
  def email_for(task)
    @email[task.to_s] if @email
  end


  # People
  # ------
  def people
    client.api.get_people(self.id).map { |p| client.model(:Person, p) }
  end

  def invite(first_name, last_name, email, admin=false)
    client.api.invite_person(self.id, first_name, last_name, email, admin)
  end

  def remove_person(person_or_id)
    id      = person_or_id.is_a?(Sprintly::Person) ? person_or_id.id : person_or_id
    payload = client.api.remove_person(self.id, id)

    client.model(:Person, payload)
  end


  # Deploys
  # -------
  def deploys
    client.api.get_deploys(self.id).map { |p| client.model(:Deploy, p) }
  end

  # Known extra params:
  # * `notes`
  # * `version`
  def record_deploy(environment, item_numbers, extra_params={})
    payload = client.api.create_deploy(self.id, environment, item_numbers, extra_params)

    client.model(:Deploy, payload)
  end


  # Persistence
  # -----------
  def sync!
    self.unpack! client.api.get_product(self.id)
  end

  def save!
    self.update!
  end

  def update!(new_attributes={})
    new_attributes = self.attributes.merge(new_attributes)

    self.unpack! client.api.update_product(self.id, new_attributes)
  end

  def archive!
    self.update! archived: true
  end

  def unarchive!
    self.update! archived: false
  end

end
