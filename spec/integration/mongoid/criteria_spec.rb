require "spec_helper"

describe Mongoid::Criteria do

  before do
    Person.delete_all
  end

  after do
    Person.delete_all
  end

  describe "#avg" do

    context "without results" do
      it "should return nil" do
        Person.avg(:age).should == nil
      end
    end

    context "with results" do
      before do
        10.times do |n|
          Person.create(:title => "Sir", :age => ((n + 1) * 10), :aliases => ["D", "Durran"], :ssn => "#{n}")
        end
      end

      it "provides min for the field provided" do
        Person.avg(:age).should == 55
      end
    end
  end

  describe "#excludes" do

    let(:person) { Person.create(:title => "Sir", :age => 100, :aliases => ["D", "Durran"], :ssn => "666666666") }

    context "when passed id" do

      it "it properly excludes ids" do
        Person.excludes(:id => person.id).entries.should be_empty
      end

    end

    context "when passed _id" do

      it "it properly excludes ids" do
        Person.excludes(:_id => person.id).entries.should be_empty
      end
    end
  end

  describe "#execute" do

    context "when reiterating" do

      let!(:person) { Person.create(:title => "Sir", :age => 100, :aliases => ["D", "Durran"], :ssn => "666666666") }

      it "executes the query again" do
        criteria = Person.all
        criteria.size.should == 1
        criteria.should_not be_empty
      end
    end
  end

  describe "#each" do

    let(:person1) { Person.create(:title => "Sir", :age => 100, :aliases => ["D", "Durran"], :ssn => "666666666") }
    let(:person2) { Person.create(:title => "Madam", :age => 1, :ssn => "098-76-5434") }

    before do
      person1.create_game(:score => 10)
      person2.create_game(:score => 20)
    end

    it "without includes" do
      criteria = Person.all
      criteria.collect(&:title).should == ["Sir", "Madam"]
    end

    it "with includes" do
      criteria = Person.includes(:game)
      criteria.collect(&:game).should == [person1.game, person2.game]
    end
  end

  describe "#in" do

    context "when searching nil values" do

      let!(:person) { Person.create(:title => nil) }

      it "returns the correct document" do
        from_db = Person.any_in(:title => [ true, false, nil ]).first
        from_db.should == person
      end
    end

    context "when searching false values" do

      let!(:person) { Person.create(:terms => false) }

      it "returns the correct document" do
        from_db = Person.criteria.in(:terms => [ true, false, nil ]).first
        from_db.should == person
      end
    end
  end

  describe "#max" do

    context "without results" do
      it "should return nil" do
        Person.max(:age).should == nil
      end
    end

    context "with results" do
      before do
        10.times do |n|
          Person.create(:title => "Sir", :age => (n * 10), :aliases => ["D", "Durran"], :ssn => "#{n}")
        end
      end

      it "provides max for the field provided" do
        Person.max(:age).should == 90.0
      end
    end
  end

  describe "#min" do

    context "without results" do
      it "should return nil" do
        Person.min(:age).should == nil
      end
    end

    context "with results" do
      before do
        10.times do |n|
          Person.create(:title => "Sir", :age => ((n + 1) * 10), :aliases => ["D", "Durran"], :ssn => "#{n}")
        end
      end

      it "provides min for the field provided" do
        Person.min(:age).should == 10.0
      end
    end
  end

  describe "#any_of" do

    before do
      5.times do |n|
        Person.create!(
          :title => "Sir",
          :age => (n * 10),
          :aliases => ["D", "Durran"],
          :ssn => "#{n}"
        )
      end
    end

    let(:criteria) do
      Person.where(:title => "Sir").cache
    end

    it "iterates over the cursor only once" do
      criteria.size.should == 5
      Person.create!(:title => "Sir")
      criteria.size.should == 5
    end
  end

  describe "#id" do

    context "when using object ids" do

      before(:all) do
        Person.identity :type => BSON::ObjectId
      end

      let!(:person) do
        Person.create(
          :title => "Sir",
          :age => 33,
          :aliases => ["D", "Durran"],
          :things => [{:phone => 'HTC Incredible'}]
        )
      end

      it 'should find object with String args' do
        Person.criteria.id(person.id.to_s).first.should == person
      end

      it 'should find object with BSON::ObjectId  args' do
        Person.criteria.id(person.id).first.should == person
      end
    end

    context "when not using object ids" do

      before(:all) do
        Person.identity :type => String
      end

      after(:all) do
        Person.identity :type => BSON::ObjectId
      end

      let!(:person) do
        Person.create(
          :title => "Sir",
          :age => 33,
          :aliases => ["D", "Durran"],
          :things => [{:phone => 'HTC Incredible'}]
        )
      end

      it 'should find object with String args' do
        Person.criteria.id(person.id.to_s).first.should == person
      end

      it 'should not find object with BSON::ObjectId  args' do
        Person.criteria.id(BSON::ObjectId(person.id)).first.should == nil
      end
    end
  end
end
