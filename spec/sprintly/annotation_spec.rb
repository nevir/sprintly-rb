describe Sprintly::Annotation do
  include_context "common client"

  subject {
    client.model(described_class, client.api.get_annotations(8094, 1).first)
  }

  describe "Attributes" do

    it "should have a verb" do
      subject.verb.should eq("Yarn")
    end

    it "should have an action" do
      subject.action.should eq("unrolled all the yarn")
    end

    it "should have a body" do
      subject.body.should eq("That dastardly feline!")
    end

    it "should have a user" do
      subject.user.should be_a(Sprintly::Person)
      subject.user.id.should eq(9708)
    end

  end

end
