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

# This class represents a hosts file and aggregates its elements.
#
# It is able to parse host files from file-system or String and can generate a
# String representation of itself to String or file-system
class Aef::Hosts::File
  COMMENT_LINE_PATTERN   = /^\s*#(.*)$/
  SECTION_MARKER_PATTERN = /^ -----(BEGIN|END) SECTION (.*)-----(?:[\r])?$/
  ENTRY_LINE_PATTERN     = /^([^#]*)(?:#(.*))?$/

  attr_accessor :path
  attr_reader :elements

  # Constructor. Initializes the object.
  #
  # The path attribute may optionally be specified
  def initialize(path = nil)
    reset
    self.path = path
  end

  # Removes all elements
  def reset
    @elements = []
  end

  # Sets the path attribute
  def path=(path)
    @path = Aef::Hosts.to_pathname(path)
  end

  # Parses a hosts file given as path
  #
  # A path must be either set as attribute or as overriding argument
  def read(path = nil)
    path = path.nil? ? @path : Aef::Hosts.to_pathname(path)

    raise ArgumentError, 'No path given' unless path
    
    parse(path.read)
  end
  
  # Parses a hosts file given as String
  def parse(data)
    current_section = self

    line_number = 1

    data.each_line do |line|
      line = Aef::Linebreak.encode(line, :unix)
    
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

          split = entry.split(/\s+/)
          split.shift if split.first == ''

          address, name, *aliases = *split

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

  # Generates a hosts file and writes it to a path
  def write(options = {})
    Aef::Hosts.validate_options(options,
      self.class.valid_option_keys_for_write)
  
    path = options[:path].nil? ? @path : Aef::Hosts.to_pathname(options[:path])

    raise ArgumentError, 'No path given' unless path
    
    options.delete(:path)

    path.open('w') do |file|
      file.write(to_s(options))
    end
    
    true
  end
  
  alias inspect to_s

  # Generates a hosts file as String
  #
  # Valid options are defined in Aef::Hosts::Element.valid_option_keys_for_to_s
  def to_s(options = {})
    Aef::Hosts.validate_options(options,
      self.class.valid_option_keys_for_to_s)
  
    string = ''

    @elements.each do |element|
      string += element.to_s(options)
    end

    string
  end
  
  # Defines valid keys for the option hash of the write method
  def self.valid_option_keys_for_write
    (valid_option_keys_for_to_s + [:path]).freeze
  end

  # Defines valid keys for the option hash of the to_s method  
  def self.valid_option_keys_for_to_s
    Aef::Hosts::Element.valid_option_keys_for_to_s
  end
end
