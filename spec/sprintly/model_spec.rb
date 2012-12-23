describe Sprintly::Model do

  let(:payload) {
    {
      "id"         => 1234,
      "name"       => "Ohai Thurr",
      "created_at" => "2012-12-12T08:13:44+04:00",
      "arr_val"    => ["one", "two", "three"],
      "admin"      => true,
      "hash_val" => {
        "fizz" => "buzz",
        "foo"  => "barf",
      }
    }
  }

  let(:model_class) {
    model_mod = described_class

    Class.new do
      include model_mod

      attribute :id
      attribute :name
      attribute :admin?
      attribute :created_at
      attribute :arr_val
    end
  }

  subject {
    model_class.new(payload, double("Sprintly::Client"))
  }

  it "should expose getters for defined attributes" do
    [:id, :name, :admin?, :created_at, :arr_val].each do |getter|
      subject.should respond_to(getter)
    end
  end

  it "should expose setters for defined attributes" do
    [:id=, :name=, :admin=, :created_at=, :arr_val=].each do |setter|
      subject.should respond_to(setter)
    end
  end

  it "should coerce ISO8601 timestamps into `Time` objects" do
    subject.created_at.should eq(Time.parse("2012-12-12T04:13:44Z"))
  end

end
