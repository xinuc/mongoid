# encoding: utf-8
module Mongoid #:nodoc:
  module Extras #:nodoc:
    extend ActiveSupport::Concern
    included do
      class_attribute :enslaved
      self.enslaved = false
      delegate :enslaved?, :to => "self.class"
    end

    module ClassMethods #:nodoc

      # Set whether or not this documents read operations should delegate to
      # the slave database by default.
      #
      # Example:
      #
      #   class Person
      #     include Mongoid::Document
      #     enslave
      #   end
      def enslave
        self.enslaved = true
      end

      # Determines if the class is enslaved or not.
      #
      # Returns:
      #
      # True if enslaved, false if not.
      def enslaved?
        !!self.enslaved
      end
    end
  end
end
