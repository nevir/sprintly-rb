describe Sprintly::Item do
  include_context "common client"

  subject do
    client.model(described_class, client.api.get_item(8094, 1))
  end

  describe "Attributes" do

    it "should have a number" do
      subject.number.should eq(1)
    end

    it "should have a type" do
      subject.type.should eq("story")
    end

    it "should have a title" do
      subject.title.should eq(
        "As an evil genius, I want to recruit a multitude of henchmen so that I am one step closer to taking over the world."
      )
    end

  end

end
