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

class Aef::Hosts::Section
  attr_accessor :name, :file, :begin_line_number, :end_line_number
  attr_reader :elements

  def initialize(name, options = {})
    Aef::Hosts.validate_options(options,
      self.class.valid_option_keys_for_initialize)

    @name              = name
    @file              = options[:file]
    @begin_line_number = options[:begin_line_number]
    @end_line_number   = options[:end_line_number]
    @elements          = options[:elements] || []
  end

  alias inspect to_s

  def to_s(options = {})
    Aef::Hosts.validate_options(options,
      self.class.valid_option_keys_for_to_s)

    header = ''
    footer = ''

    if name
      if not @file or
         not @begin_line_number or
         not @end_line_number or
         options[:force_generation]

        header = "# -----BEGIN SECTION #{name}-----\n"
        footer = "# -----END SECTION #{name}-----\n"
      else
        header = @file.lines[@begin_line_number]
        footer = @file.lines[@end_line_number - 1]
      end
    end

    string = header

    elements.each do |element|
      string += element.to_s(options)
    end

    string += footer
  end

  protected

  def self.valid_option_keys_for_initialize
    @valid_option_keys_for_initialize ||= [:file, :begin_line_number, :end_line_number, :elements].freeze
  end

  def self.valid_option_keys_for_to_s
    @valid_option_keys_for_to_s ||= [:force_generation].freeze
  end
end
