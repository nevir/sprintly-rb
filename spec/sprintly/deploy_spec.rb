describe Sprintly::Deploy do
  include_context "common client"

  subject {
    client.model(described_class, client.api.get_deploys(8094).first)
  }

  describe "Attributes" do

    it "should have an environment" do
      subject.environment.should eq("staging")
    end

    it "should have a version" do
      subject.version.should eq("0.27.93")
    end

    it "should have notes" do
      subject.notes.should eq("A most EVIL deployment!")
    end

    it "should have a user" do
      subject.user.should be_a(Sprintly::Person)
      subject.user.id.should eq(9708)
    end

    it "should have items" do
      subject.items.all? { |i| i.is_a? Sprintly::Item }.should be_true
      subject.items.map(&:number).should eq([1, 3, 4, 6, 10, 15])
    end

  end

end
