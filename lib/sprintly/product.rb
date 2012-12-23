# Product
# =======
class Sprintly::Product
  include Sprintly::Model

  # Attributes
  # ----------
  attribute :id
  attribute :name
  attribute :created_at
  attribute :archived?
  attribute :admin?

  # The email address for a particular task type.
  #
  # See [the support documentation](http://help.sprint.ly/knowledgebase/articles/102435-creating-new-bugs-tasks-and-tests-via-email-)
  # for more information.
  def email_for(task)
    @email[task.to_s] if @email
  end


  # Relationships
  # -------------
  def people
    @client.api.get_people(self.id).map { |p| Sprintly::Person.new(p, @client) }
  end


  # API Calls
  # ---------
  def update!
    self.unpack! @client.api.get_product(self.id)
  end

  def archive!
    self.unpack! @client.api.archive_product(self.id)
  end

  def unarchive!
    self.unpack! @client.api.update_product(self.id, archived: false)
  end

end
