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

class Aef::Hosts::Element
  include ActiveModel::Dirty

  attr_reader :cache

  def invalidate_cache
    @cache = nil
  end

  def cache_filled?
    @cache ? true : false
  end

  alias inspect to_s

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

    string
  end

  protected

  def self.valid_option_keys_for_to_s
    @valid_option_keys_for_to_s ||= [:force_generation].freeze
  end
  
  def generate_string(options = {})
    raise NotImplementedError
  end

  def cache_string(options = {})
    @cache
  end
end
