describe Sprintly::Person do
  include_context "common client"

  subject do
    described_class.new(client.api.get_person(8094, 9709), client)
  end

  describe "Attributes" do

    it "should have an id" do
      subject.id.should eq(9709)
    end

    it "should have a name" do
      subject.name.should eq("Professor Bigglesworth")
      subject.first_name.should eq("Professor")
      subject.last_name.should  eq("Bigglesworth")
    end

    it "should have an email address" do
      subject.email.should eq("drbiggles@nevir.net")
    end

    it "should have an admin flag" do
      subject.should be_an_admin
    end

  end

end
