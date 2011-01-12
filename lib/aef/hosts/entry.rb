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

class Aef::Hosts::Entry < Aef::Hosts::Element
  define_attribute_methods [:address, :name, :comment, :aliases]

  attr_accessor :address, :name, :comment
  attr_reader :aliases

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
    [address, name, *aliases].join(' ') + " ##{comment}\n"
  end
end
