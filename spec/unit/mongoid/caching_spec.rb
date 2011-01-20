require "spec_helper"

describe Mongoid::Caching do

  describe ".caching" do

    it "starts with an empty identity map" do
      Person.cache! do |klass|
        klass.cache.should be_empty
      end
    end

    context "when completing the block" do

      context "when setting documents in the identity map" do

        let(:post_one) do
          Post.new
        end

        let(:post_two) do
          Post.new
        end

        let(:criteria) do
          Post.where(:person_id => BSON::ObjectId.new)
        end

        before do
          criteria.expects(:entries).returns([ post_one, post_two ])
          Post.cache! do |klass|
            klass.cache.set(criteria)
          end
        end

        it "expires the cache after the block" do
          Post.cache.should be_empty
        end
      end
    end

    context "when inside the block" do

      context "when setting documents in the identity map" do

        let(:post_one) do
          Post.new
        end

        let(:post_two) do
          Post.new
        end

        let(:criteria) do
          Post.where(:person_id => BSON::ObjectId.new)
        end

        before do
          criteria.expects(:entries).returns([ post_one, post_two ])
          Post.cache!
          Post.cache.set(criteria)
        end

        after do
          Post.expire_cache!
        end

        it "sets the documents in the map" do
          Post.cache.get(criteria).should == [ post_one, post_two ]
        end
      end
    end
  end
end
