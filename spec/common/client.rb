shared_context "common client" do

  let(:client) {
    creds = Common::Configuration.credentials[:test]

    Sprintly::Client.new(creds[:email], creds[:token])
  }

end
