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

class Aef::Hosts::Entry < Aef::Hosts::Element
  define_attribute_methods [:address, :name, :comment, :aliases]

  attr_accessor :address, :name, :comment
  attr_reader :aliases

  # Constructor. Initializes the object.
  #
  # Address and name must be set
  #
  # Possible options:
  #
  # Through :aliases, an Array of aliases can be set.
  # Through :comment, a String comment can be set.
  # Through :cache, a cached String representation can be set.
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

  def address=(address)
    address_will_change! unless address.equal?(@address)
    @address = address
  end

  def name=(name)
    name_will_change! unless name.equal?(@name)
    @name = name
  end

  def comment=(comment)
    comment_will_change! unless comment.equal?(@comment)
    @comment = comment
  end

  def aliases=(aliases)
    aliases_will_change! unless aliases.equal?(@aliases)
    @aliases = aliases
  end

  protected

  def self.valid_option_keys_for_initialize
    @valid_option_keys_for_initialize ||= [:aliases, :comment, :cache].freeze
  end
  
  def generate_string(options = nil)
    if comment
      suffix = " ##{comment}\n"
    else
      suffix = "\n"
    end
  
    [address, name, *aliases].join(' ') + suffix
  end
end
