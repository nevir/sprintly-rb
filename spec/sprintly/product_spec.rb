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

    it "should list all deploys" do
      deploys = subject.deploys

      deploys.map(&:environment).should eq([
        "staging",
        "production",
      ])
    end

    it "should allow new deploys to be recorded" do
      with_fixture_set(:creates) do
        deploy = subject.record_deploy(:staging, [1,3,4,6,10,15],
          version: "0.27.93",
          notes:   "A most EVIL deployment!",
        )

        deploy.version.should eq("0.27.93")
      end
    end

  end

  describe "Persistence" do

    it "should get updates when calling sync!" do
      product = subject # Initial request is made
      with_fixture_set(:updates) do
        subject.sync!
      end

      # We expect it twice: Once when creating the subject, and again on update.
      a_request(:get, %r{/api/products/8094}).should have_been_made.twice
      subject.name.should eq("World Dominashun")
      subject.email_for(:defects).should be_nil
    end

    it "should archive when calling archive!" do
      with_fixture_set(:archivals) do
        subject.should_not be_archived
        subject.archive!

        a_request(:post, %r{/api/products/8094}).should have_been_made.once
        subject.should be_archived
      end
    end

    it "should support saving" do
      product = subject # Initial request is made prior to save
      with_fixture_set(:updates) do
        subject.name = "World Dominashun"
        subject.save!
      end

      a_request(:post, %r{/api/products/8094}).should have_been_made.once
        subject.name.should eq("World Dominashun")
    end

    describe "with an archived product" do

      subject do
        all_products = client.api.get_products

        described_class.new(all_products.find { |p| p["id"] == 8202}, client)
      end

      it "should raise an error when syncing" do
        expect { subject.sync! }.to raise_error(Sprintly::Error::Archived)
      end

      it "should unarchive when calling unarchive!" do
        with_fixture_set(:restores) do
          subject.should be_archived
          subject.unarchive!

          a_request(:post, %r{/api/products/8202}).should have_been_made.once
          subject.should_not be_archived
        end
      end

    end

  end

end
