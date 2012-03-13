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

    # Represents a comment-only line as element of a hosts file
    class Comment < Element
      
      define_attribute_methods [:comment]

      # The comment
      #
      # @return [String]
      attr_accessor :comment

      # Initializes a comment
      #
      # @param comment [String] the comment
      # @param options [Hash]
      # @option options [String] :cache sets a cached String representation
      def initialize(comment, options = {})
        validate_options(options, :cache)
        
        raise ArgumentError, 'Comment cannot be empty' unless comment

        @comment = comment.to_s
        @cache   = options[:cache].to_s unless options[:cache].nil?
      end

      # Sets the comment
      def comment=(comment)
        comment_will_change! unless comment.equal?(@comment)
        @comment = comment
      end

      # A String representation for debugging purposes
      #
      # @return [String]
      def inspect
        generate_inspect(:comment, :cache)
      end

      protected

      # Defines the algorithm to generate a String representation from scratch.
      #
      # @return [String] a generated String representation
      def generate_string(options = {})
        "##{comment}\n"
      end
    end

  end
end

