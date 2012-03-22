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

    # Represents an entry line as element of a hosts file
    class Entry < Element
      
      # The network address
      #
      # @return [String]
      attr_reader :address

      # The primary hostname for the address
      #
      # @return [String]
      attr_reader :name

      # Optional comment
      #
      # @return [String]
      attr_reader :comment

      # Optional alias hostnames
      #
      # @return [Array<String>]
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
        validate_options(options, :aliases, :comment, :cache)

        raise ArgumentError, 'Address cannot be empty' unless address
        raise ArgumentError, 'Name cannot be empty' unless name

        @address = address.to_s
        @name    = name.to_s
        @aliases = options[:aliases] || []
        @comment = options[:comment].to_s unless options[:comment].nil?
        @cache   = options[:cache].to_s unless options[:cache].nil?
      end

      # Sets the network address
      def address=(address)
        set_if_changed(:address, address.to_s) do
          invalidate_cache!
        end
      end

      # Sets the primary hostname for the address
      def name=(name)
        set_if_changed(:name, name.to_s) do
          invalidate_cache!
        end
      end

      # Sets the optional comment
      def comment=(comment)
        set_if_changed(:comment, comment.to_s) do
          invalidate_cache!
        end
      end

      # Sets the optional alias hostnames
      def aliases=(aliases)
        set_if_changed(:aliases, [*aliases]) do
          invalidate_cache!
        end
      end

      # A String representation for debugging purposes
      #
      # @return [String]
      def inspect
        generate_inspect(self, :address, :name, :aliases, :comment, :cache)
      end

      protected

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

        [address, name, *aliases].join(' ') << suffix
      end

    end
  end
end
