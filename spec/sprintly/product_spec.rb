describe Sprintly::Product do
  include_context "common client"

  subject do
    client.model(described_class, client.api.get_product(8094))
  end

  describe "Attributes" do

    it "should have an id" do
      subject.id.should eq(8094)
    end

    it "should have a name" do
      subject.name.should eq("World Domination")
    end

    it "should have a created timestamp" do
      subject.created_at.should eq(Time.parse("2012-12-18T08:13:44+00:00"))
    end

    it "should have an admin flag for the current user" do
      subject.should be_admin
    end

    it "should indicate whether it is current archived" do
      subject.should_not be_archived
    end

    [:tests, :tasks, :stories, :defects, :backlog].each do |kind|
      it "should expose email addresses for #{kind} updates" do
        subject.email_for(kind).should eq("#{kind}-8094@items.sprint.ly")
      end
    end

    it "should not explode for unknown email addresses" do
      subject.email_for(:unknown).should be_nil
    end

  end

  describe "Relationships" do

    it "should expose the people that have access to this product" do
      people = subject.people

      people.all? { |p| p.should be_a(Sprintly::Person) }
      people.map(&:name).sort.should eq(
        ["Bogart Furbottom", "Fluffy McFaddon", "Professor Bigglesworth"]
      )
    end

  end

  describe "API Calls" do

    it "should get updates when calling update!" do
      product = subject # Initial request is made
      with_fixture_set(:updates) do
        subject.update!
      end

      # We expect it twice: Once when creating the subject, and again on update.
      a_request(:get, %r{/api/products/8094}).should have_been_made.twice
      subject.name.should eq("World Dominashun")
      subject.email_for(:defects).should be_nil
    end

    it "should archive when calling archive!" do
      subject.archive!

      a_request(:delete, %r{/api/products/8094}).should have_been_made.once
      subject.should be_archived
    end

    describe "with an archived product" do

      subject do
        all_products = client.api.get_products

        described_class.new(all_products.find { |p| p["id"] == 8202}, client)
      end

      it "should raise an error when updating" do
        expect { subject.update! }.to raise_error(Sprintly::Error::Archived)
      end

      it "should unarchive when calling unarchive!" do
        with_fixture_set(:restores) do
          subject.unarchive!
        end

        a_request(:post, %r{/api/products/8202}).should have_been_made.once
        subject.should_not be_archived
      end

    end

  end

end
