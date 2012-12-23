describe Sprintly::Client do
  include_context "common client"

  subject { client }

  describe "requests" do

    subject {
      described_class.new("fizz@example.com", "3347f7730e7caba2e7ae16e8884c93bb65e836ac")
    }

    it "should use basic authentication when making requests" do
      stub_request(:get, "https://fizz%40example.com:3347f7730e7caba2e7ae16e8884c93bb65e836ac@sprint.ly/api/fake.json").to_return(
        body: "{\"hi\": \"and stuff\"}",
      )
      subject.get("fake")["hi"].should eq("and stuff")
    end

    [:get, :post, :delete].each do |verb|
      it "should provide a #{verb} helper" do
        stub_request(verb, /.*sprint\.ly\/api\/fake\.json/).to_return(
          body: "{\"body\": \"for #{verb}\"}",
        )
        subject.send(verb, "fake")["body"].should eq("for #{verb}")
      end
    end

  end

  describe "properties" do

    it "should expose the configured options for the client" do
      client = described_class.new("email", "token", endpoint: "https://custom/endpoint")

      client.options.should eq(endpoint: "https://custom/endpoint")
    end

    it "should expose an instance of `Sprintly::API` for the client" do
      Sprintly::API.should_receive(:new).with(subject)
      subject.api
    end

    it "should expose the faraday object for extended customization" do
      subject.connection.should be_a(Faraday::Connection)
    end

  end

  describe "API calls" do

    it "should expose the current user's products" do
      subject.products.map(&:name).sort.should eq(
        ["Investigation of Warms", "Pelage Cleanliness", "Subvocalization", "World Domination"]
      )
    end

    it "should allow creation of new products" do
      new_product = subject.create_product("Subvocalization")

      a_request(:post, %r{/api/products}).should have_been_made.once
      new_product.name.should eq("Subvocalization")
    end

  end

end
