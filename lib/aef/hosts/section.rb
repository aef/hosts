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

    # This represents a section as element of a hosts file. It consists of a
    # header, futher included elements and a footer
    class Section < Element

      define_attribute_methods [:name]

      # Title of the section
      #
      # @return [String]
      attr_reader :name

      # Elements inside the section
      #
      # @return [Aef::Host::Element]
      attr_accessor :elements

      # Initializes a section
      #
      # @param [String] name title of the section
      # @param [Hash] options
      # @option options [String] :cache sets a cached String representation
      # @option options [Array<Aef::Hosts::Element>] :elements a list of
      #   elements in the section
      def initialize(name, options = {})
        validate_options(options, :cache, :elements)

        raise ArgumentError, 'Name cannot be empty' unless name

        @name     = name.to_s
        @elements = options[:elements] || []
        @cache    = options[:cache] || {:header => nil, :footer => nil}
      end

      # Deletes the cached String representation
      #
      # @param [Hash] options
      # @option [true, false] :only_section if set to true, the invalidation
      #   will not cascade onto the elements. Default is false.
      # @return [Aef::Hosts::Section] a self reference
      def invalidate_cache!(options = {})
        @cache = {:header => nil, :footer => nil}

        unless options[:only_section]
          elements.each do |element|
            element.invalidate_cache!
          end
        end
      end

      # Tells if a String representation is cached or not
      #
      # @return [true, false] true if cache is not empty
      def cache_filled?
        @cache[:header] and @cache[:footer]
      end

      # Sets the title of the section
      def name=(name)
        name_will_change! unless name.equal?(@name)
        @name = name
      end

      # A String representation for debugging purposes
      #
      # @return [String]
      def inspect
        generate_inspect(self, :name, :cache, :elements)
      end

      protected

      # Defines the algorithm to generate a String representation from scratch.
      #
      # @return [String] a generated String representation
      def generate_string(options = {})
        string = ''

        string << "# -----BEGIN SECTION #{name}-----\n"

        @elements.each do |element|
          string << element.to_s(options)
        end

        string << "# -----END SECTION #{name}-----\n"

        string
      end

      # Defines the algorithm to construct the String representation from cache
      #
      # @return [String] the cached String representation
      def cache_string(options = {})
        string = ''

        string << @cache[:header]

        @elements.each do |element|
          string << element.to_s(options)
        end

        string << @cache[:footer]

        string
      end

    end
  end
end
