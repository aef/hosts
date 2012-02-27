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

# This represents a section as element of a hosts file. It consists of a header,
# futher included elements and a footer
class Aef::Hosts::Section < Aef::Hosts::Element
  # Defines valid keys for the option hash of the constructor
  def self.valid_option_keys_for_initialize
    [:cache, :elements].freeze
  end

  define_attribute_methods [:name]
  
  attr_accessor :name
  attr_reader :elements
  
  # Constructor. Initializes the object.
  #
  # A name for the section must be specified
  #
  # Possible options:
  #
  # Through :cache, a cached String representation can be set.
  #
  # Through :elements, an Array of elements can be set.
  def initialize(name, options = {})
    Aef::Hosts.validate_options(options,
      self.class.valid_option_keys_for_initialize)

    raise ArgumentError, 'Name cannot be empty' unless name

    @name     = name
    @elements = options[:elements] || []
    @cache    = options[:cache] || {:header => nil, :footer => nil}
  end

  # Tells if a String representation is cached or not
  def cache_filled?
    @cache[:header] and @cache[:footer]
  end
  
  # Sets the name attribute
  #
  # This implicitly invalidates the cache
  def name=(name)
    name_will_change! unless name.equal?(@name)
    @name = name
  end
  
  protected

  # Defines the algorithm to generate a String representation from scratch.
  def generate_string(options = {})
    string = ''
    
    string += "# -----BEGIN SECTION #{name}-----\n"

    @elements.each do |element|
      string += element.to_s(options)
    end
 
    string += "# -----END SECTION #{name}-----\n"

    string
  end

  # Defines the custom algorithm to construct a String representation from cache.
  def cache_string(options = {})
    string = ''

    string += @cache[:header]

    @elements.each do |element|
      string += element.to_s(options)
    end

    string += @cache[:footer]

    string
  end
end
