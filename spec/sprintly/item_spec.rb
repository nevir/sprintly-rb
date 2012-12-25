describe Sprintly::Item do
  include_context "common client"

  subject do
    client.model(described_class, client.api.get_item(8094, 1))
  end

  describe "Attributes" do

    describe "identity" do

      it "should have a number" do
        subject.number.should eq(1)
      end

      it "should embed a Product" do
        subject.product.should be_a(Sprintly::Product)
        subject.product.id.should eq(8094)
      end

      it "should embed an author" do
        subject.created_by.should be_a(Sprintly::Person)
        subject.created_by.id.should eq(9708)
      end

    end

    describe "content" do

      it "should have a who (if a story)" do
        subject.who.should eq("evil genius")
      end

      it "should have a what (if a story)" do
        subject.what.should eq("to recruit a multitude of henchmen")
      end

      it "should have a why (if a story)" do
        subject.why.should eq("I am one step closer to taking over the world")
      end

      it "should have a title" do
        subject.title.should eq(
          "As an evil genius, I want to recruit a multitude of henchmen so that I am one step closer to taking over the world."
        )
      end

    end

    describe "statuses" do

      it "should have a type" do
        subject.type.should eq(:story)
      end

      it "should have a status" do
        subject.status.should eq(:backlog)
      end

      it "should indicate whether it is archived" do
        subject.should_not be_archived
      end

      pending "should indicate who it is assigned to"

      it "should have a score" do
        subject.score.should eq(:XL)
      end

    end

    describe "metadata" do

      pending "should list its tags"

      [:files, :discussion].each do |kind|
        it "should expose email addresses for #{kind} updates" do
          subject.email_for(kind).should match(%r{#{kind}-\d+@items.sprint.ly})
        end
      end

      it "should have a created timestamp" do
        subject.created_at.should be_a(Time)
      end

      it "should have a last modified timestamp" do
        subject.last_modified.should be_a(Time)
      end

    end

  end

  describe "Relationships" do

    it "should expose any child items" do
      children = subject.children.sort_by(&:number)
      children.map(&:number).should eq([2,3,4,5,6])
      children.map(&:title).should eq([
        "Check Craigslist",
        "Check 4chan for remote henchmen",
        "Reach out to past henchmen",
        "Determine henchmen quality bar",
        "Set up henching contract w/ Wolfram & Hart",
      ])
    end

    it "should expose any annotations" do
      annotations = subject.annotations

      annotations.map(&:action).should eq([
        "unrolled all the yarn",
        "re-rolled the yarn into a pristine state",
        "unrolled all the yarn",
      ])
      annotations.map(&:user).map(&:id).should eq([9708, 9708, 9708])
    end

    it "should expose any attachments" do
      attachments = subject.attachments

      attachments.map(&:name).should eq([
        "il_fullxfull.301243805.jpg",
        "_jack_spicer_evil_cat_genius___xsfa__by_takachino-d4khtqm.png"
      ])
    end

  end

  describe "Mutation" do

    it "should allow creation of new annotations" do
      new_annotation = subject.append_annotation(
        verb:   "Yarn",
        action: "unrolled all the yarn",
        body:   "That dastardly feline!",
      )

      new_annotation.user.should be_a(Sprintly::Person)
      new_annotation.user.id.should eq(9708)
      new_annotation.action.should eq("unrolled all the yarn")
    end

  end

end
