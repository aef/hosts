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
  include ActiveModel::Dirty

  define_attribute_methods [:address, :name, :comment, :aliases]

  attr_accessor :address, :name, :comment, :file, :line_number
  attr_reader :aliases

  def initialize(address, name, options = {})
    Aef::Hosts.validate_options(options,
      self.class.valid_option_keys_for_initialize)

    raise ArgumentError, 'Address cannot be empty' unless address
    raise ArgumentError, 'Name cannot be empty' unless name

    @address     = address
    @name        = name
    @aliases     = options[:aliases]
    @comment     = options[:comment]
    @file        = options[:file]
    @line_number = options[:line_number]
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

  alias inspect to_s

  def to_s(options = {})
    Aef::Hosts.validate_options(options,
      self.class.valid_option_keys_for_to_s)

    if not @file or
       not @line_number or
       options[:force_generation] or
       changed?

      [address, name, *aliases].join(' ') + "\n"
    else
      @file.lines[line_number - 1]
    end
  end

  protected

  def self.valid_option_keys_for_initialize
    @valid_option_keys_for_initialize ||= [:aliases, :comment, :file, :line_number].freeze
  end

  def self.valid_option_keys_for_to_s
    @valid_option_keys_for_to_s ||= [:force_generation].freeze
  end
end
