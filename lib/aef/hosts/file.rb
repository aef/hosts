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

class Aef::Hosts::File
  COMMENT_LINE_PATTERN   = /^#(.*)$/
  SECTION_MARKER_PATTERN = /^ -----(BEGIN|END) SECTION (.*)-----(?:[\r])?$/
  ENTRY_LINE_PATTERN     = /^([^#]*)(?:#(.*))?$/

  attr_accessor :path
  attr_reader :elements

  def initialize(path = nil)
    reset
    self.path = path
  end

  def reset
    @elements = []
  end

  def path=(path)
    @path = Aef::Hosts.to_pathname(path)
  end

  def read(path = nil)
    path = path.nil? ? @path : Aef::Hosts.to_pathname(path)

    raise ArgumentError, 'No path given' unless path

    current_section = self

    line_number = 1

    path.read.each_line do |line|
      line_number += 1

      if COMMENT_LINE_PATTERN =~ line
        comment = $1

        if SECTION_MARKER_PATTERN =~ comment
          type = $1
          name = $2

          case type
          when 'BEGIN'
            unless current_section.name
              current_section = Aef::Hosts::Section.new(
                name,
                :cache => {:header => line, :footer => nil}
              )
            else
              raise Aef::Hosts::ParserError, "Invalid cascading of sections. Cannot start new section '#{name}' without first closing section '#{current_section.name}' in #{path.realpath} on line #{line_number}"
            end
          when 'END'
            if name == current_section.name
              current_section.cache[:footer] = line
              current_section = add_section
            else
              raise Aef::Hosts::ParserError, "Invalid closing of section. Found attempt to close section '#{name}' in body of section '#{current_section.name}' in #{path.realpath} on line #{line_number}"
            end
          end
        else
          current_section.elements << Aef::Hosts::Comment.new(
            comment,
            :cache => line
          )
        end
      else
        ENTRY_LINE_PATTERN =~ line

        entry   = $1
        comment = $2

        if entry and not entry =~ /^\s+$/

          address, name, *aliases = entry.split(/\s+/)

          current_section.elements << Aef::Hosts::Entry.new(
            address, name,
            :aliases => aliases,
            :comment => comment,
            :cache   => line
          )
        else
          current_section.elements << Aef::Hosts::EmptyElement.new(
            :cache => line
          )
        end
      end
    end

    true
  end

  def write(path = nil)
    path = path.nil? ? @path : to_pathname(path)

    raise ArgumentError, 'No path given' unless path
  end

  alias inspect to_s

  def to_s(options = {})
    string = ''

    @elements.each do |element|
      string += element.to_s(options)
    end

    string
  end
end
