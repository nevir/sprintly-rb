describe Sprintly::ItemFavorite do
  include_context "common client"

  subject {
    client.model(described_class, client.api.get_item_favorite(8094, 1, 5292))
  }

  describe "Attributes" do

    it "should have an id" do
      subject.id.should eq(5292)
    end

    it "should have a blocked user" do
      subject.user.should be_a(Sprintly::Person)
      subject.user.id.should eq(9708)
    end

    it "should have a timestamp" do
      subject.created_at.should eq(Time.parse("2012-12-25T13:03:54-08:00"))
    end

  end

end
