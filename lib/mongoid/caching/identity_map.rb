# encoding: utf-8
module Mongoid #:nodoc:
  module Caching #:nodoc:

    # Used for storing documents temporarily in memory by their ids in order to
    # minimize database queries.
    class IdentityMap < Hash

      # Create the new identity map, providing an optional hash of values.
      #
      # @example Create the new map.
      #   IdentityMap.new(person.id => person)
      #
      # @param [ Hash ] attributes The ids and documents.
      #
      # @return [ IdentityMap ] The new map.
      #
      # @since 2.0.0.rc.7
      def initialize(attributes = {})
        merge!(attributes)
      end

      # Set a document in the identity map. The id will become the key.
      #
      # @example Set a document in the map.
      #   map.set(criteria, people)
      #
      # @param [ Criteria ] criteria The criteria to cache.
      #
      # @return [ Array<Document> ] The cached document(s).
      #
      # @since 2.0.0.rc.7
      def set(criteria)
        self[criteria.selector] = criteria.entries
      end

      # Retrieve a document from the map. If the key does not exist, return
      # nil.
      #
      # @example Get the document from the map.
      #   map.get(person.id)
      #
      # @param [ Criteria ] criteria The criteria to get the cached docs for.
      #
      # @return [ Array<Document>, nil ] The document(s) if found or nil.
      #
      # @since 2.0.0.rc.7
      def get(criteria)
        return nil unless criteria.is_a?(Mongoid::Criteria)
        self[criteria.selector]
      end
    end
  end
end
