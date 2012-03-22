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

    # This class represents a hosts file and aggregates its elements.
    #
    # It is able to parse host files from file-system or String and can
    # generate a String representation of itself to String or file-system.
    class File

      include Helpers

      # Regular expression to extract a comment line.
      #
      # @private
      COMMENT_LINE_PATTERN   = /^\s*#(.*)$/

      # Regular expression to extract section headers and footers.
      #
      # @private
      SECTION_MARKER_PATTERN = /^ -----(BEGIN|END) SECTION (.*)-----(?:[\r])?$/

      # Regular expression to extract entry lines.
      #
      # @private
      ENTRY_LINE_PATTERN     = /^([^#]*)(?:#(.*))?$/

      # The hosts file's elements.
      #
      # @return [Array<Aef::Hosts::Element>]
      attr_accessor :elements

      # The filesystem path of the hosts file.
      #
      # @return [Pathname, nil]
      attr_reader :path

      class << self
        # Parses a hosts file given as path.
        #
        # @param [Pathname] the hosts file path
        # @return [Aef::Hosts::File] a file
        def read(path)
          new(path).read
        end

        # Parses a hosts file given as String.
        #
        # @param [String] data a String representation of the hosts file
        # @return [Aef::Hosts::File] a file
        def parse(data)
          new.parse(data)
        end
      end

      # Initializes a file.
      #
      # @param [Pathname] path path to the hosts file
      def initialize(path = nil)
        reset
        self.path = path
      end

      # Removes all elements.
      #
      # @return [Aef::Hosts::File] a self reference
      def reset
        @elements = []

        self
      end

      # Deletes the cached String representations of all elements.
      #
      # @return [Aef::Hosts::File] a self reference
      def invalidate_cache!
        elements.each do |element|
          element.invalidate_cache!
        end

        self
      end

      # Sets the filesystem path of the hosts file.
      def path=(path)
        @path = to_pathname(path)
      end

      # Parses a hosts file given as path.
      #
      # @param [Pathname] path override the path attribute for this operation
      # @return [Aef::Hosts::File] a self reference
      def read(path = nil)
        path = path.nil? ? @path : to_pathname(path)

        raise ArgumentError, 'No path given' unless path

        parse(path.read)

        self
      end

      # Parses a hosts file given as String.
      #
      # @param [String] data a String representation of the hosts file
      # @return [Aef::Hosts::File] a self reference
      def parse(data)
        current_section = self

        data.to_s.lines.each_with_index do |line, line_number|
          line = Linebreak.encode(line, :unix)

          if COMMENT_LINE_PATTERN =~ line
            comment = $1

            if SECTION_MARKER_PATTERN =~ comment
              type = $1
              name = $2

              case type
              when 'BEGIN'
                unless current_section.is_a?(Section)
                  current_section = Section.new(
                    name,
                    :cache => {:header => line, :footer => nil}
                  )
                else
                  raise ParserError, "Invalid cascading of sections. Cannot start new section '#{name}' without first closing section '#{current_section.name}' on line #{line_number + 1}."
                end
              when 'END'
                if name == current_section.name
                  current_section.cache[:footer] = line
                  elements << current_section
                  current_section = self
                else
                  raise ParserError, "Invalid closing of section. Found attempt to close section '#{name}' in body of section '#{current_section.name}' on line #{line_number + 1}."
                end
              end
            else
              current_section.elements << Comment.new(
                comment,
                :cache => line
              )
            end
          else
            ENTRY_LINE_PATTERN =~ line

            entry   = $1
            comment = $2

            if entry and not entry =~ /^\s+$/

              split = entry.split(/\s+/)
              split.shift if split.first == ''

              address, name, *aliases = *split

              current_section.elements << Entry.new(
                address, name,
                :aliases => aliases,
                :comment => comment,
                :cache   => line
              )
            else
              current_section.elements << EmptyElement.new(
                :cache => line
              )
            end
          end
        end

        self
      end

      # Generates a hosts file and writes it to a path.
      #
      # @param [Hash] options
      # @option options [Pathname] :path overrides the path attribute for this
      #   operation
      # @option options [true, false] :force_generation if set to true, the
      #   cache won't be used, even if it not empty
      # @option options [:unix, :windows, :mac] :linebreak_encoding the
      #   linebreak encoding of the result. If nothing is specified the result
      #   will be encoded as if :unix was specified.
      # @see Aef::Linebreak#encode
      def write(options = {})
        validate_options(options, :force_generation, :linebreak_encoding, :path)

        path = options[:path].nil? ? @path : to_pathname(options[:path])

        raise ArgumentError, 'No path given' unless path

        options.delete(:path)

        path.open('w') do |file|
          file.write(to_s(options))
        end

        true
      end

      # A String representation for debugging purposes.
      #
      # @return [String]
      def inspect
        generate_inspect(self, :path, :elements)
      end

      # A String representation of the hosts file.
      #
      # @param [Hash] options
      # @option options [true, false] :force_generation if set to true, the
      #   cache won't be used, even if it not empty
      # @option options [:unix, :windows, :mac] :linebreak_encoding the
      #   linebreak encoding of the result. If nothing is specified the result
      #   will be encoded as if :unix was specified.
      # @see Aef::Linebreak#encode
      def to_s(options = {})
        validate_options(options, :force_generation, :linebreak_encoding)

        string = ''

        @elements.each do |element|
          string << element.to_s(options)
        end

        string
      end

    end
  end
end
