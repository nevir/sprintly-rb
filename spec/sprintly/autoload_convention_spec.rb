describe Sprintly::AutoloadConvention do

  let(:namespace) {
    mod = Module.new do
      class << self
        def name
          "Fixtures::AutoloadConvention"
        end
        alias :inspect :name
      end
    end
    mod.extend subject

    mod
  }

  it "should raise a LoadError when referencing an unknown constant" do
    expect { namespace::Foo }.to raise_error(LoadError)
  end

  it "should raise a NameError when the file exists, but the wrong constant is defined" do
    expect { namespace::Mismatched }.to raise_error(NameError)
  end

  it "should load single-token files" do
    namespace::Single.should eq(:single_and_stuff)
  end

  it "should load multi-token files" do
    namespace::MultiToken.should eq(:multi)
  end

  it "shouldn't split ACRONYMS" do
    namespace::ALLCAPS.should eq(:yelling)
  end

  it "shouldn't pick up constants in parent namespaces" do
    namespace::String.should eq("I am a string!")
  end

end
