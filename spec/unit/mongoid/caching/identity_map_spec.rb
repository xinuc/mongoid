require "spec_helper"

describe Mongoid::Caching::IdentityMap do

  let(:person) do
    Person.new
  end

  let(:criteria) do
    Game.where(:person_id => person.id)
  end

  describe "#get" do

    let(:map) do
      described_class.new({ criteria.selector => [ person ] })
    end

    context "when the document is found" do

      it "returns the document" do
        map.get(criteria).should == [ person ]
      end
    end

    context "when the document is not found" do

      it "returns nil" do
        map.get("1").should be_nil
      end
    end
  end

  describe "#set" do

    let(:map) do
      described_class.new
    end

    before do
      criteria.expects(:entries).returns([ person ])
      map.set(criteria)
    end

    it "sets the key as the document id" do
      map.should have_key(criteria.selector)
    end

    it "sets the value as the document" do
      map.values.first.should == [ person ]
    end
  end
end
