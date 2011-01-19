# encoding: utf-8
require "mongoid/caching/identity_map"

module Mongoid #:nodoc:

  # This module provides caching behaviour at the class level, used in
  # conjunction with identity maps.
  module Caching
    extend ActiveSupport::Concern

    module ClassMethods #:nodoc:

      # Start the block where the identity map will be used, and expire on
      # finish.
      #
      # @example Execute a cache sequence.
      #   Person.cache! do |model|
      #     model.cache.set(document)
      #   end
      #
      # @since 2.0.0.rc.6
      def cache!
        yield(self) and expire_cache! if block_given?
      end

      # Get the cache from the class or create a new one.
      #
      # @example Get the cache.
      #   Person.cache
      #
      # @return [ IdentityMap ] The existing or new identity map.
      #
      # @since 2.0.0.rc.6
      def cache
        @cache ||= IdentityMap.new
      end

      # Expire the cache manually.
      #
      # @example Expire the cache.
      #   Person.expire_cache!
      #
      # @since 2.0.0.rc.6
      def expire_cache!
        cache.clear
      end
    end
  end
end
