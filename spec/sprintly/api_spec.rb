# Mostly just sanity checking.
describe Sprintly::API do

  let(:client) {
    double(:"Sprintly::Client")
  }

  subject {
    described_class.new(client)
  }


  # Annotations
  # -----------
  it "should hit the correct endpoint for get_annotations" do
    client.should_receive(:get).with("products/12/items/23/annotations")
    subject.get_annotations(12, 23)
  end

  it "should hit the correct endpoint for append_annotation" do
    client.should_receive(:post).with("products/12/items/23/annotations",
      label: "App", action: "did something super awesome", body: "**sweet!**",
    )
    subject.append_annotation(12, 23, label: "App", action: "did something super awesome", body: "**sweet!**")
  end


  # Attachments
  # -----------
  it "should hit the correct endpoint for get_attachments" do
    client.should_receive(:get).with("products/12/items/23/attachments")
    subject.get_attachments(12, 23)
  end

  it "should hit the correct endpoint for get_attachment" do
    client.should_receive(:get).with("products/12/items/23/attachments/34")
    subject.get_attachment(12, 23, 34)
  end


  # Blocking
  # --------
  it "should hit the correct endpoint for get_blocked_items" do
    client.should_receive(:get).with("products/12/items/23/blocking")
    subject.get_blocked_items(12, 23)
  end

  it "should hit the correct endpoint for mark_item_blocked" do
    client.should_receive(:post).with("products/12/items/23/blocking", blocked: 34)
    subject.mark_item_blocked(12, 23, 34)
  end

  it "should hit the correct endpoint for get_blocked_item" do
    client.should_receive(:get).with("products/12/items/23/blocking/34")
    subject.get_blocked_item(12, 23, 34)
  end

  it "should hit the correct endpoint for unblock_item" do
    client.should_receive(:delete).with("products/12/items/23/blocking/34")
    subject.unblock_item(12, 23, 34)
  end


  # Comments
  # --------
  it "should hit the correct endpoint for get_comments" do
    client.should_receive(:get).with("products/12/items/23/comments")
    subject.get_comments(12, 23)
  end

  it "should hit the correct endpoint for get_comment" do
    client.should_receive(:get).with("products/12/items/23/comments/34")
    subject.get_comment(12, 23, 34)
  end

  it "should hit the correct endpoint for create_comment" do
    client.should_receive(:post).with("products/12/items/23/comments", body: "message and stuff")
    subject.create_comment(12, 23, "message and stuff")
  end

  it "should hit the correct endpoint for delete_comment" do
    client.should_receive(:delete).with("products/12/items/23/comments/34")
    subject.delete_comment(12, 23, 34)
  end


  # Deploys
  # -------
  it "should hit the correct endpoint for get_deploys" do
    client.should_receive(:get).with("products/12/deploys")
    subject.get_deploys(12)
  end

  it "should hit the correct endpoint for create_deploy" do
    client.should_receive(:post).with("products/12/deploys",
      environment: "staging", numbers: "23,34,45",
    )
    subject.create_deploy(12, "staging", [23, 34, 45])
  end


  # Favorites
  # ---------
  it "should hit the correct endpoint for get_favoriting_users" do
    client.should_receive(:get).with("products/12/items/23/favorites")
    subject.get_favoriting_users(12, 23)
  end

  it "should hit the correct endpoint for mark_item_as_favorite" do
    client.should_receive(:post).with("products/12/items/23/favorites")
    subject.mark_item_as_favorite(12, 23)
  end

  it "should hit the correct endpoint for get_favoriting_user" do
    client.should_receive(:get).with("products/12/items/23/favorites/34")
    subject.get_favoriting_user(12, 23, 34)
  end

  it "should hit the correct endpoint for delete_favorite" do
    client.should_receive(:delete).with("products/12/items/23/favorites/34")
    subject.delete_favorite(12, 23, 34)
  end


  # Items
  # -----
  it "should hit the correct endpoint for get_items" do
    client.should_receive(:get).with("products/12/items",
      status: "backlog", children: true
    )
    subject.get_items(12, status: "backlog", children: true)
  end

  it "should hit the correct endpoint for create_item" do
    client.should_receive(:post).with("products/12/items",
      type: "story", who: "dev", what: "a well tested API", why: "to avoid regressions",
    )
    subject.create_item(12,
      type: "story", who: "dev", what: "a well tested API", why: "to avoid regressions",
    )
  end

  it "should hit the correct endpoint for get_item" do
    client.should_receive(:get).with("products/12/items/23")
    subject.get_item(12, 23)
  end

  it "should hit the correct endpoint for update_item" do
    client.should_receive(:post).with("products/12/items/23", description: "for great justice!")
    subject.update_item(12, 23, description: "for great justice!")
  end

  it "should hit the correct endpoint for archive_item" do
    client.should_receive(:delete).with("products/12/items/23")
    subject.archive_item(12, 23)
  end

  it "should hit the correct endpoint for get_child_items" do
    client.should_receive(:get).with("products/12/items/23/children")
    subject.get_child_items(12, 23)
  end


  # People
  # ------
  it "should hit the correct endpoint for get_people" do
    client.should_receive(:get).with("products/12/people")
    subject.get_people(12)
  end

  it "should hit the correct endpoint for invite_person" do
    client.should_receive(:post).with("products/12/people",
      first_name: "Fizz", last_name: "Boffin", email: "fizz@boff.com", admin: false,
    )
    subject.invite_person(12, "Fizz", "Boffin", "fizz@boff.com")
  end

  it "should hit the correct endpoint for get_person" do
    client.should_receive(:get).with("products/12/people/23")
    subject.get_person(12, 23)
  end

  it "should hit the correct endpoint for remove_person" do
    client.should_receive(:delete).with("products/12/people/23")
    subject.remove_person(12, 23)
  end


  # Products
  # --------
  it "should hit the correct endpoint for get_products" do
    client.should_receive(:get).with("products")
    subject.get_products
  end

  it "should hit the correct endpoint for create_product" do
    client.should_receive(:post).with("products", name: "Awesomesauce")
    subject.create_product("Awesomesauce")
  end

  it "should hit the correct endpoint for get_product" do
    client.should_receive(:get).with("products/12")
    subject.get_product(12)
  end

  it "should hit the correct endpoint for update_product" do
    client.should_receive(:post).with("products/12", archived: "n", name: "Ohai")
    subject.update_product(12, name: "Ohai", archived: false)
  end

  it "should hit the correct endpoint for archive_product" do
    client.should_receive(:delete).with("products/12")
    subject.archive_product(12)
  end

end
