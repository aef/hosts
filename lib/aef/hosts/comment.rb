# encoding: UTF-8
=begin
Copyright Alexander E. Fischer <aef@raxys.net>, 2012

This file is part of Hosts.

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
=end

require 'aef/hosts'

class Aef::Hosts::Comment < Aef::Hosts::Element
  define_attribute_methods [:comment]

  attr_accessor :comment

  def initialize(comment, options = {})
    Aef::Hosts.validate_options(options,
      self.class.valid_option_keys_for_initialize)

    raise ArgumentError, 'Name cannot be empty' unless comment

    @comment = comment
    @cache   = options[:cache]
  end

  def comment=(comment)
    comment_will_change! unless comment.equal?(@comment)
    @comment = comment
  end

  protected
  
  def self.valid_option_keys_for_initialize
    @valid_option_keys_for_initialize ||= [:comment, :cache].freeze
  end

  def generate_string(options = {})
    "##{comment}\n"
  end
end
