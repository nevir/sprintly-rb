describe Sprintly::Model do

  let(:payload) {
    {
      "id"         => 1234,
      "name"       => "Ohai Thurr",
      "type"       => "awesome",
      "created_at" => "2012-12-12T08:13:44+04:00",
      "arr_val"    => ["one", "two", "three"],
      "admin"      => true,
      "hash_val" => {
        "fizz" => "buzz",
        "foo"  => "barf",
      },
      "many_good" => [
        1, 2, 3
      ]
    }
  }

  let(:model_class) {
    model_mod = described_class

    Class.new do
      include model_mod

      attribute :id, read_only: true
      attribute :name
      attribute :type,       :Symbol
      attribute :admin?
      attribute :created_at, :Time
      attribute :arr_val,    :GoodType
      attribute :bad,        :BadType
      attribute :many_good,  Array[:GoodType]
    end
  }

  let(:client) {
    double("Sprintly::Client").tap do |result|
      result.stub(:model).with(:BadType, anything).and_raise(LoadError, "bad module or something")
      result.stub(:model).with(:GoodType, anything) { "Good!" }
    end
  }

  subject {
    model_class.new(payload, client)
  }

  it "should expose getters for defined attributes" do
    [:id, :name, :admin?, :created_at, :arr_val].each do |getter|
      subject.should respond_to(getter)
    end
  end

  it "should expose setters for defined attributes" do
    [:name=, :admin=, :created_at=, :arr_val=].each do |setter|
      subject.should respond_to(setter)
    end
  end

  it "should not expose setters for read-only attributes" do
    subject.should_not respond_to(:id=)
  end

  it "should not unpack attributes that start with _" do
    subject.unpack! "_foo" => 1234

    subject.instance_variable_defined?(:@_foo).should_not be_true
  end

  it "should expose all the attributes via a hash" do
    subject.attributes.should eq(
      id:         1234,
      name:       "Ohai Thurr",
      type:       :awesome,
      admin:      true,
      created_at: Time.parse("2012-12-12T08:13:44+04:00"),
      arr_val:    "Good!",
      bad:        nil,
      many_good:  ["Good!", "Good!", "Good!"],
    )
  end

  describe "attribute types" do

    it "should raise an error for unknown attribute types" do
      expect { subject.unpack! bad: "foo" }.to raise_error(/BadType/)
    end

    it "should coerce Time objects" do
      subject.created_at.should eq(Time.parse("2012-12-12T04:13:44Z"))
    end

    it "should coerce Symbol objects" do
      subject.type.should eq(:awesome)
    end

    it "should coerce attributes in setters" do
      subject.created_at = "2000-01-01T01:23:45Z"
      subject.created_at.should eq(Time.parse("2000-01-01T01:23:45Z"))
    end

    it "should coerce known model types" do
      subject.arr_val.should eq("Good!")
    end

    it "should support lists of known types, too" do
      subject.many_good.should eq(["Good!", "Good!", "Good!"])
    end

  end

end
