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

require 'aef/hosts'

# Represents an empty line as element of a hosts file
class Aef::Hosts::EmptyElement < Aef::Hosts::Element
  # Defines valid keys for the option hash of the constructor
  def self.valid_option_keys_for_initialize
    [:cache].freeze
  end

  # Constructor. Initializes the object.
  #
  # Possible options:
  #
  # Through :cache, a cached String representation can be set.
  def initialize(options = {})
    Aef::Hosts.validate_options(options,
      self.class.valid_option_keys_for_initialize)

    @cache = options[:cache]
  end

  protected

  # Defines the algorithm to generate a String representation from scratch.
  def generate_string(options = {})
    "\n"
  end
end
