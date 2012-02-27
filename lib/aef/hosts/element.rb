# encoding: UTF-8
#
# Copyright Alexander E. Fischer <aef@raxys.net>, 2010
#
# This file is part of Hosts.
#
# Hosts is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
