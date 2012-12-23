describe Sprintly::Error do

  def failing_request(status, message="Things went wrong")
    double("Faraday::Request").tap do |request|
      request.stub(:body) { {"message" => message, "code" => status} }
      request.stub(:status) { status }
    end
  end

  describe "with status code" do

    subject do
      described_class.new("Stuff Broke", 527)
    end

    it "should expose the status code when printing" do
      subject.to_s.should include("HTTP status 527")
    end

    it "should expose the status code when inspecting" do
      subject.inspect.should include("HTTP status 527")
    end

  end

  describe "#from_response" do

    it "should fall back to Sprintly::Error if there is no mapping" do
      error = described_class.from_response(failing_request(999))
      error.should be_a(Sprintly::Error)
    end

    # Just make sure each error file loads properly, effectively
    described_class::STATUS_MAPPING.each do |status, class_name|
      it "should map #{status} statuses to Sprintly::Error::#{class_name}" do
        error = described_class.from_response(failing_request(status))
        error.should be_a(Sprintly::Error.const_get(class_name))
      end
    end

  end

end
