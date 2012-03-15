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

unless defined?(Rubinius)
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
  end
end

require 'set'
require 'pathname'
require 'tmpdir'
require 'rspec'
require 'pry'
require 'aef/hosts'

module Aef::Hosts::SpecHelper
  def create_temp_dir
    Pathname(Dir.mktmpdir('hosts_spec'))
  end
  
  def fixtures_dir
    Pathname(__FILE__).dirname + 'fixtures'
  end
end

RSpec.configure do |config|
  config.include Aef::Hosts::SpecHelper
end

