# Product
# =======
require "time"

class Sprintly::Product

  def initialize(payload, client)
    self.unpack! payload

    @client = client
  end


  # Attributes
  # ----------
  attr_reader :id
  attr_reader :name
  attr_reader :created_at

  def archived?
    @is_archived
  end

  # Whether or not the current user is an admin of this product.
  def admin?
    @is_admin
  end

  # The email address for a particular task type.
  #
  # See [the support documentation](http://help.sprint.ly/knowledgebase/articles/102435-creating-new-bugs-tasks-and-tests-via-email-)
  # for more information.
  def email_for(task)
    @emails[task.to_s]
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


  # State Management
  # ----------------

  # Unpacks a product payload and updates this object's state with it.
  #
  # Sample payload:
  #
  # {
  #   "id": 8094,
  #   "name": "World Domination",
  #   "created_at": "2012-12-18T08:13:44+00:00",
  #   "archived": false,
  #   "admin": true,
  #   "email": {
  #     "tests": "tests-8094@items.sprint.ly",
  #     "tasks": "tasks-8094@items.sprint.ly",
  #     "stories": "stories-8094@items.sprint.ly",
  #     "defects": "defects-8094@items.sprint.ly",
  #     "backlog": "backlog-8094@items.sprint.ly"
  #   }
  # }
  #
  def unpack!(payload)
    @id          = payload["id"]
    @name        = payload["name"]
    @created_at  = Time.parse(payload["created_at"])
    @is_archived = payload["archived"]
    @is_admin    = payload["admin"]
    @emails      = payload["email"]
  end

end
