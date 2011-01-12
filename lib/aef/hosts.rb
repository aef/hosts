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

require 'set'
require 'pathname'
require 'active_model'

# Namespace for projects of Alexander E. Fischer <aef@raxys.net>
#
# If you want to be able to simply type Example instead of Aef::Example to
# address classes in this namespace simply write the following before using the
# classes:
#
#  include Aef
module Aef

  module Hosts
    VERSION = '0.1.0'.freeze

    autoload :File,         'aef/hosts/file'
    autoload :Element,      'aef/hosts/element'
    autoload :Section,      'aef/hosts/section'
    autoload :Entry,        'aef/hosts/entry'
    autoload :Comment,      'aef/hosts/comment'
    autoload :EmptyElement, 'aef/hosts/empty_element'

    module_function
    def validate_options(options, valid_keys)
      options.keys.each do |key|
        raise ArgumentError, "Invalid option key: :#{key}" unless valid_keys.include?(key)
      end
    end

    def to_pathname(path)
      unless path.nil?
        Pathname(path)
      end
    end

    class ParserError < RuntimeError; end
  end
end
