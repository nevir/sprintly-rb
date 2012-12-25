describe Sprintly::ItemBlock do
  include_context "common client"

  subject {
    client.model(described_class, client.api.get_blocked_item(8094, 1, 1884))
  }

  describe "Attributes" do

    it "should have an id" do
      subject.id.should eq(1884)
    end

    it "should have an item" do
      subject.item.should be_a(Sprintly::Item)
      subject.item.number.should eq(1)
    end

    it "should have a blocked item" do
      subject.blocked.should be_a(Sprintly::Item)
      subject.blocked.number.should eq(9)
    end

    it "should have a blocked user" do
      subject.user.should be_a(Sprintly::Person)
      subject.user.id.should eq(9709)
    end

  end

end
