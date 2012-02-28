# encoding: UTF-8
=begin
Copyright Alexander E. Fischer <aef@raxys.net>, 2012

This file is part of Hosts.

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
=end

require 'aef/hosts'

module Aef
  module Hosts

    # The base class for elements which are aggregated by the Aef::Hosts::File
    # class.
    #
    # @abstract This class is not supposed to be instantiated.
    class Element

      # Used to automatically invalidate the cache if marked attributes are changed
      include ActiveModel::Dirty

      # @return [String] cached String representation
      attr_reader :cache

      # Deletes the cached String representation
      #
      # @return [Aef::Hosts::Element] a self reference
      def invalidate_cache
        @cache = nil

        self
      end

      # Tells if a String representation is cached or not
      #
      # @return [true, false] true if cache is not empty
      def cache_filled?
        @cache ? true : false
      end

      alias inspect to_s

      # Provides a String representation of the element
      #
      # @param [Hash] options
      # @option options [true, false] :force_generation if set to true, the
      #   cache won't be used, even if it not empty
      # @option options [:unix, :windows, :mac] :linebreak_encoding the
      #   linebreak encoding of the result. If nothing is specified the result
      #   will be encoded as if :unix was specified.
      # @see Aef::Linebreak#encode
      def to_s(options = {})
        Aef::Hosts.validate_options(options,
          self.class.valid_option_keys_for_to_s)

        string = ''

        if not cache_filled? or
           options[:force_generation] or
           changed?

          string += generate_string(options)
        else
          string += cache_string(options)
        end

        if options[:linebreak_encoding]
          string = Aef::Linebreak.encode(string, options[:linebreak_encoding])
        end

        string
      end

      # Defines valid keys for the option hash of the to_s method
      def self.valid_option_keys_for_to_s
        [:force_generation, :linebreak_encoding].freeze
      end

      protected

      # Defines the algorithm to generate a String representation from scratch.
      #
      # @abstract This method needs to be implemented in descendant classes.
      # @return [String] a generated String representation
      def generate_string(options = {})
        raise NotImplementedError
      end

      # Defines the algorithm to construct the String representation from cache
      #
      # FIXME: Return copy of the cache instead of reference
      #
      # @return [String] the cached String representation
      def cache_string(options = {})
        @cache
      end
    end

  end
end

