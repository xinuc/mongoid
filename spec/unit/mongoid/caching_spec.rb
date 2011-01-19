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

        before do
          Person.cache! do |klass|
            klass.cache.set(post_one)
            klass.cache.set(post_two)
          end
        end

        it "expires the cache after the block" do
          Person.cache.should be_empty
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

        before do
          Person.cache!
          Person.cache.set(post_one)
          Person.cache.set(post_two)
        end

        after do
          Person.expire_cache!
        end

        it "sets the first document in the map" do
          Person.cache.get(post_one.id).should == post_one
        end

        it "sets the second document in the map" do
          Person.cache.get(post_two.id).should == post_two
        end
      end
    end
  end
end
