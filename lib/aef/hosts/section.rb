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

class Aef::Hosts::Section < Aef::Hosts::Element
  define_attribute_methods [:name]
  
  attr_accessor :name
  attr_reader :elements

  def initialize(name, options = {})
    Aef::Hosts.validate_options(options,
      self.class.valid_option_keys_for_initialize)

    raise ArgumentError, 'Name cannot be empty' unless name

    @name     = name
    @elements = options[:elements] || []
    @cache    = options[:cache] || {:header => nil, :footer => nil}
  end

  def cache_filled?
    @cache[:header] and @cache[:footer]
  end
  
  def name=(name)
    name_will_change! unless name.equal?(@name)
    @name = name
  end

  protected

  def self.valid_option_keys_for_initialize
    @valid_option_keys_for_initialize ||= [:cache, :elements].freeze
  end
  
  def generate_string(options = {})
    string = ''
    
    string += "# -----BEGIN SECTION #{name}-----\n"

    @elements.each do |element|
      string += element.to_s(options)
    end
 
    string += "# -----END SECTION #{name}-----\n"

    string
  end

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
