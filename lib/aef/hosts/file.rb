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

  attr_accessor :path, :linebreak_encoding
  attr_reader :sections, :lines

  def initialize(path = nil)
    reset
    self.path = path
  end

  def reset
    @lines    = []
    @sections = []

    add_section
  end

  def path=(path)
    @path = Aef::Hosts.to_pathname(path)
  end

  def add_section(name = nil, options = {})
    if @sections.last
      begin_line_number = @sections.last.end_line_number
    else
      begin_line_number = 1
    end

    section = Aef::Hosts::Section.new(name,
      :file              => self,
      :begin_line_number => begin_line_number
    )

    @sections << section
    section
  end

  def read(path = nil)
    path = path.nil? ? @path : Aef::Hosts.to_pathname(path)

    raise ArgumentError, 'No path given' unless path

    current_section = @sections.first

    linebreak_encodings = Set.new

    path.read.each_line do |line|
      linebreak_encodings += Aef::Linebreak.encodings(line)
      @lines << line.freeze

      if COMMENT_LINE_PATTERN =~ line
        comment = $1

        if SECTION_MARKER_PATTERN =~ comment
          type = $1
          name = $2

          case type
          when 'BEGIN'
            unless current_section.name
              current_section = add_section(
                name,
                :begin_line_number => @lines.length
              )
            else
              raise Aef::Hosts::ParserError, "Invalid cascading of sections. Cannot start new section '#{name}' without first closing section '#{current_section.name}' in #{path.realpath} on line #{@lines.length}"
            end
          when 'END'
            if name == current_section.name
              current_section.end_line_number = @lines.length
              current_section = add_section
            else
              raise Aef::Hosts::ParserError, "Invalid closing of section. Found attempt to close section '#{name}' in body of section '#{current_section.name}' in #{path.realpath} on line #{@lines.length}"
            end
          end
        else
          current_section.elements << Aef::Hosts::Comment.new(
            comment,
            :file        => self,
            :line_number => @lines.length
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
            :aliases     => aliases,
            :comment     => comment,
            :file        => self,
            :line_number => @lines.length
          )
        else
          current_section.elements << Aef::Hosts::EmptyEntry.new(
            :file        => self,
            :line_number => @lines.length
          )
        end
      end

      current_section.end_line_number = @lines.length
    end

    @lines.freeze

    unless @linebreak_encoding
      if linebreak_encodings.length == 1
        @linebreak_encoding = linebreak_encodings.first
      else
        if Config::CONFIG['host_os'] =~ /mswin|mingw/
          @linebreak_encoding = :windows
        else
          @linebreak_encoding = :unix
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

    sections.each do |section|
      string += section.to_s(options)
    end

    string
  end
end
