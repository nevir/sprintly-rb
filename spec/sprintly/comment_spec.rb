describe Sprintly::Comment do
  include_context "common client"

  subject {
    client.model(described_class, client.api.get_comment(8094, 1, 181698))
  }

  describe "Attributes" do

    it "should have an id" do
      subject.id.should eq(181698)
    end

    it "should have a body" do
      subject.body.should eq("Poster idea ^^^  ([found via etsy](http://www.etsy.com/listing/90076611/guild-of-calamitous-intent-recruitment))")
    end

    it "should have a person" do
      subject.created_by.should be_a(Sprintly::Person)
      subject.created_by.id.should eq(9708)
    end

  end

end
