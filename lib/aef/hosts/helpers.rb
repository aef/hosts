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

    # Helper methods used internally in the hosts library
    #
    # @private
    module Helpers

      protected

      # Ensures that an options Hash has includes only valid keys
      #
      # @param [Hash] options the options Hash to verify
      # @param [Array<Symbol>] valid_keys a list of valid keys for the Hash
      # @raise [ArgumentError] if Hash includes invalid keys
      def validate_options(options, *valid_keys)
        remainder = options.keys - valid_keys

        unless remainder.empty?
          raise ArgumentError, "Invalid option keys: :#{remainder.join(',')}"
        end
      end

      # Casts a given object to Pathname or passes through a given nil
      #
      # @param [String, Pathname, nil] path a filesystem path
      # @return [Pathname, nil]
      def to_pathname(path)
        path.nil? ? nil : Pathname.new(path)
      end

      # Generates a string representation for debugging purposes.
      #
      # @param [Array<Symbol, String>] attributes to be displayed. If given as
      #   Symbol, the attribute's value will be presented by name and the
      #   inspect output of its value. If given as String, the String will
      #   represent it instead.
      # @return [String] a string representation for debugging purposes
      def generate_inspect(*attributes)
        string = "#<#{self.class}"

        components = []

        attributes.each do |attribute|
          if attribute == :cache
            components << 'cached!' if send(:cache_filled?)
          elsif attribute == :elements
            components << generate_elements_partial(elements)
          elsif attribute.is_a?(Symbol)
            components << "#{attribute}=#{send(attribute).inspect}"
          else
            components << attribute
          end          
        end

        components.unshift(':') unless components.empty?
        
        string << components.join(' ')
        string << '>'
      end

      # Generate a partial String for an element listing in inspect output.
      #
      # @return [String] element partial
      def generate_elements_partial(elements)
        elements_string = "elements={\n"

        elements.each do |element|
          elements_string << " #{element.inspect}\n"
        end

        elements_string << "}"
      end

    end
  end
end
