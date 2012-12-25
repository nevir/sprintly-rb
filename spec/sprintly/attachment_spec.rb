describe Sprintly::Attachment do
  include_context "common client"

  subject {
    client.model(described_class, client.api.get_attachment(8094, 1, 27046))
  }

  describe "Attributes" do

    it "should have a name" do
      subject.name.should eq("il_fullxfull.301243805.jpg")
    end

    it "should have a href" do
      subject.href.should eq("https://sprint.ly/product/8094/file/27046")
    end

    it "should have an author" do
      subject.created_by.should be_a(Sprintly::Person)
      subject.created_by.id.should eq(9708)
    end

    it "should have a created timestamp" do
      subject.created_at.should eq(Time.parse("2012-12-25T11:07:59-08:00"))
    end

  end

end
