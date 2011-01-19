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
      # @since 2.0.0.rc.6
      def initialize(attributes = {})
        merge!(attributes)
      end

      # Set a document in the identity map. The id will become the key.
      #
      # @example Set a document in the map.
      #   map.set(person)
      #
      # @param [ Document ] document The document to cache.
      #
      # @return [ Document ] The document that was set.
      #
      # @since 2.0.0.rc.6
      def set(document)
        self[document.id] = document
      end

      # Retrieve a document from the map. If the key does not exist, return
      # nil.
      #
      # @example Get the document from the map.
      #   map.get(person.id)
      #
      # @param [ BSON::ObjectId, String, Object ] id The document's id.
      #
      # @return [ Document, nil ] The document if found or nil.
      #
      # @since 2.0.0.rc.6
      def get(id)
        self[id]
      end
    end
  end
end
