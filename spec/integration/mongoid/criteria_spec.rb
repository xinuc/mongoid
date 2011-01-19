require "spec_helper"

describe Mongoid::Criteria do

  before do
    Person.delete_all
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
