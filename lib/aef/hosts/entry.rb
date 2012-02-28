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
    class Entry < Element
      define_attribute_methods [:address, :name, :comment, :aliases]

      attr_accessor :address, :name, :comment
      attr_reader :aliases

      # Initializes an entry.
      #
      # @param [String] address the network address
      # @param [String] name the primary hostname for the address
      # @param [Hash] options
      # @option options [Array<String>] :aliases a list of aliases for the
      #   address
      # @option options [String] :comment a comment for the entry
      # @option options [String] :cache a cached String representation
      def initialize(address, name, options = {})
        Aef::Hosts.validate_options(options,
          self.class.valid_option_keys_for_initialize)

        raise ArgumentError, 'Address cannot be empty' unless address
        raise ArgumentError, 'Name cannot be empty' unless name

        @address = address
        @name    = name
        @aliases = options[:aliases] || []
        @comment = options[:comment]
        @cache   = options[:cache]
      end

      # @attribute [String] address the network address
      def address=(address)
        address_will_change! unless address.equal?(@address)
        @address = address
      end

      # @attribute [String] name the primary hostname for the address
      def name=(name)
        name_will_change! unless name.equal?(@name)
        @name = name
      end

      # @attribute [String] comment comment for the entry
      def comment=(comment)
        comment_will_change! unless comment.equal?(@comment)
        @comment = comment
      end

      # @attribute [Array<String>] aliases a list of aliases for the address
      def aliases=(aliases)
        aliases_will_change! unless aliases.equal?(@aliases)
        @aliases = aliases
      end

      protected

      def self.valid_option_keys_for_initialize
        @valid_option_keys_for_initialize ||= [:aliases, :comment, :cache].freeze
      end

      # Defines the algorithm to generate a String representation from scratch.
      #
      # @abstract This method needs to be implemented in descendant classes.
      # @return [String] a generated String representation
      def generate_string(options = nil)
        if comment
          suffix = " ##{comment}\n"
        else
          suffix = "\n"
        end

        [address, name, *aliases].join(' ') + suffix
      end

    end
  end
end
