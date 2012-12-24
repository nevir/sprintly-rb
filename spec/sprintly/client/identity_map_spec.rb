describe Sprintly::Client::IdentityMap do

  let(:client_class) {
    identity_map_mod = described_class

    Class.new do
      include identity_map_mod

      def model_class(class_name)
        require "fixtures/client/identity_map/#{class_name}"
        Fixtures::Client::IdentityMap.const_get(class_name)
      end
    end
  }

  subject {
    client_class.new
  }

  it "should allow creation of new models" do
    subject.model(:Simple, id: 123, name: "Hi")
  end

  it "should throw if the identity is nil" do
    expect { subject.model(:Simple, {}) }.to raise_error(/identity cannot be nil/)
  end

  it "should allow for clearing of the identity map" do
    old_model = subject.model(:Simple, id: 123, name: "Hi")

    subject.clear_identity_map!

    new_model = subject.model(:Simple, id: 123, name: "Hi")

    new_model.object_id.should_not eq(old_model.object_id)
  end

  it "should handle complex identities" do
    new_model     = subject.model(:Complex, one: 1, two: 2)
    updated_model = subject.model(:Complex, one: 1, two: 2, message: "stuff")

    updated_model.object_id.should eq(new_model.object_id)
    new_model.message.should eq("stuff")
  end

  it "should allow lookup of identity by class or class name" do
    require "fixtures/client/identity_map/simple"

    new_model     = subject.model(Fixtures::Client::IdentityMap::Simple, id: 27)
    updated_model = subject.model(:Simple, id: 27, name: "stuff")

    updated_model.object_id.should eq(new_model.object_id)
    new_model.name.should eq("stuff")
  end

  describe "with existing model" do

    let(:existing) {
      subject.model(:Simple, id: 123, name: "Hi")
    }

    it "should preserve the identity of existing models" do
      updated_model = subject.model(:Simple, id: 123, name: "Hi")

      updated_model.object_id.should eq(existing.object_id)
    end

    it "should update existing attributes" do
      existing.name.should eq("Hi")

      subject.model(:Simple, id: 123, name: "Bye")

      existing.name.should eq("Bye")
    end

    it "should not remove missing attributes" do
      subject.model(:Simple, id: 123)

      existing.name.should eq("Hi")
    end

    it "should insert new attributes" do
      existing.other.should be_nil

      subject.model(:Simple, id: 123, other: "stuff")

      existing.other.should eq("stuff")
    end

  end

end
