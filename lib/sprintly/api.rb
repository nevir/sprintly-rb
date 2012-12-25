# Direct API Access
# =================
class Sprintly::API

  def initialize(client)
    @client = client
  end

  attr_reader :client


  # Annotations
  # -----------
  # http://help.sprint.ly/knowledgebase/articles/98416-annotations
  def get_annotations(product_id, item_number)
    result = self.client.get("products/#{product_id}/items/#{item_number}/annotations")
    # To allow for proper identification of the annotations
    result.each do |annotation|
      annotation["product_id"]  = product_id
      annotation["item_number"] = item_number
    end

    result
  end

  def append_annotation(product_id, item_number, params={})
    # for consistency's sake, translate verb -> label
    params[:label] = params.delete(:verb) if params.has_key? :verb

    result = self.client.post("products/#{product_id}/items/#{item_number}/annotations", params)
    result["product_id"]  = product_id
    result["item_number"] = item_number

    result
  end


  # Attachments
  # -----------
  # http://help.sprint.ly/knowledgebase/articles/112045-attachments
  def get_attachments(product_id, item_number)
    self.client.get("products/#{product_id}/items/#{item_number}/attachments")
  end

  def get_attachment(product_id, item_number, attachment_id)
    self.client.get("products/#{product_id}/items/#{item_number}/attachments/#{attachment_id}")
  end


  # Blocking
  # --------
  # http://help.sprint.ly/knowledgebase/articles/98414-blocking
  def get_blocked_items(product_id, item_number)
    self.client.get("products/#{product_id}/items/#{item_number}/blocking")
  end

  def mark_item_blocked(product_id, item_number, blocked_by_item_number)
    self.client.post("products/#{product_id}/items/#{item_number}/blocking",
      blocked: blocked_by_item_number,
    )
  end

  # Is `block_id` an item number, or a separate id space?
  def get_blocked_item(product_id, item_number, block_id)
    self.client.get("products/#{product_id}/items/#{item_number}/blocking/#{block_id}")
  end

  def unblock_item(product_id, item_number, block_id)
    self.client.delete("products/#{product_id}/items/#{item_number}/blocking/#{block_id}")
  end


  # Comments
  # --------
  # http://help.sprint.ly/knowledgebase/articles/98413-comments
  def get_comments(product_id, item_number)
    self.client.get("products/#{product_id}/items/#{item_number}/comments")
  end

  def get_comment(product_id, item_number, comment_id)
    self.client.get("products/#{product_id}/items/#{item_number}/comments/#{comment_id}")
  end

  def create_comment(product_id, item_number, body)
    self.client.post("products/#{product_id}/items/#{item_number}/comments",
      body: body,
    )
  end

  def delete_comment(product_id, item_number, comment_id)
    self.client.delete("products/#{product_id}/items/#{item_number}/comments/#{comment_id}")
  end


  # Deploys
  # -------
  # http://help.sprint.ly/knowledgebase/articles/138392-deploys
  def get_deploys(product_id)
    self.client.get("products/#{product_id}/deploys")
  end

  def create_deploy(product_id, environment, item_numbers)
    self.client.post("products/#{product_id}/deploys",
      environment: environment,
      numbers:     item_numbers.join(","),
    )
  end


  # Favorites
  # ---------
  # http://help.sprint.ly/knowledgebase/articles/98415-favorites
  def get_item_favorites(product_id, item_number)
    self.client.get("products/#{product_id}/items/#{item_number}/favorites")
  end

  # Marks for the current user.
  def mark_item_as_favorite(product_id, item_number)
    self.client.post("products/#{product_id}/items/#{item_number}/favorites")
  end

  def get_item_favorite(product_id, item_number, favorite_id)
    self.client.get("products/#{product_id}/items/#{item_number}/favorites/#{favorite_id}")
  end

  def delete_item_favorite(product_id, item_number, favorite_id)
    self.client.delete("products/#{product_id}/items/#{item_number}/favorites/#{favorite_id}")
  end


  # Items
  # -----
  # http://help.sprint.ly/knowledgebase/articles/98412-items
  #
  # For all items calls, the official docs are your best reference; there are
  # a lot of potential arguments.
  def get_items(product_id, params={})
    self.client.get("products/#{product_id}/items", params)
  end

  def create_item(product_id, params={})
    self.client.post("products/#{product_id}/items", params)
  end

  def get_item(product_id, item_number)
    self.client.get("products/#{product_id}/items/#{item_number}")
  end

  def update_item(product_id, item_number, params={})
    self.client.post("products/#{product_id}/items/#{item_number}", params)
  end

  def archive_item(product_id, item_number)
    self.client.delete("products/#{product_id}/items/#{item_number}")
  end

  def get_child_items(product_id, item_number)
    self.client.get("products/#{product_id}/items/#{item_number}/children")
  end


  # People
  # ------
  # http://help.sprint.ly/knowledgebase/articles/98410-people
  def get_people(product_id)
    self.client.get("products/#{product_id}/people")
  end

  def invite_person(product_id, first_name, last_name, email, admin=false)
    self.client.post("products/#{product_id}/people",
      first_name: first_name,
      last_name:  last_name,
      email:      email,
      admin:      admin,
    )
  end

  def get_person(product_id, user_id)
    self.client.get("products/#{product_id}/people/#{user_id}")
  end

  def remove_person(product_id, user_id)
    self.client.delete("products/#{product_id}/people/#{user_id}")
  end


  # Products
  # --------
  # http://help.sprint.ly/knowledgebase/articles/98355-products
  def get_products
    self.client.get("products")
  end

  def create_product(name)
    self.client.post("products",
      name: name,
    )
  end

  def get_product(product_id)
    self.client.get("products/#{product_id}")
  end

  # Currently, you can either update the name of the product, or set its
  # archived status.
  def update_product(product_id, options={})
    params = {}
    params[:name] = options[:name] if options.has_key? :name
    if options.has_key? :archived
      params[:archived] = options[:archived] ? "y" : "n"
    end

    self.client.post("products/#{product_id}", params)
  end

  def archive_product(product_id)
    self.client.delete("products/#{product_id}")
  end

end
