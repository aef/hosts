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

# The base class for elements which are aggregated by the Aef::Hosts::File class
#
# This is meant to be abstract. It is not supposed to be instantiated.
class Aef::Hosts::Element
  # Used to automatically invalidate the cache if marked attributes are changed
  include ActiveModel::Dirty
  
  # Cached String representation is stored here
  attr_reader :cache

  # Deletes the cached String representation
  def invalidate_cache
    @cache = nil
  end

  # Tells if a String representation is cached or not
  def cache_filled?
    @cache ? true : false
  end

  alias inspect to_s
  
  # Provides a String representation of the element
  #
  # Possible options:
  #
  # If :force_generation is set to true, the cache won't be used, even if it
  # exists and the representation is generated from scratch.
  #
  # If :linebreak_encoding is set to :unix, :windows or :mac, the representation
  # will be re-encoded. If nothing is given, the representation can be expected
  # to be encoded for UNIX-like system.
  # See documentation of the gem "linebreak" for more information.
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
  # This method is abstract. It needs to be implemented in child classes.
  def generate_string(options = {})
    raise NotImplementedError
  end

  # Defines the algorithm to construct the String representation from cache
  def cache_string(options = {})
    @cache
  end
end
