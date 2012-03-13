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

require 'spec_helper'

describe Aef::Hosts::EmptyElement do
  let(:element) { described_class.new }

  describe "cache attribute" do
    it "should exist" do
      element.should respond_to(:cache)
    end

    it "should be nil by default" do
      element.cache.should be_nil
    end

    it "should not be allowed to be set" do
      element.should_not respond_to(:cache=)
    end

    it "should be settable through the constructor" do
      element = Aef::Hosts::EmptyElement.new(:cache => "   \n")

      element.cache.should == "   \n"
    end

    it "should be correctly reported as empty by cache_filled?" do
      element.should respond_to(:cache_filled?)

      element.cache_filled?.should be_false
    end

    it "should be correctly reported as filled by cached_filled?" do
      element = Aef::Hosts::EmptyElement.new(:cache => "   \n")

      element.should respond_to(:cache_filled?)

      element.cache_filled?.should be_true
    end

    it "should be invalidatable" do
      element = Aef::Hosts::EmptyElement.new(:cache => "   \n")

      element.invalidate_cache!

      element.cache.should be_nil
    end
  end

  describe "string generation" do
    it "should generate new output if no cache is available" do
      element.to_s.should == "\n"
    end

    it "should respond with a duplicate of the cached content if cache is filled" do
      element = Aef::Hosts::EmptyElement.new(:cache => "   \n")

      element.to_s.should == "   \n"
      element.to_s.should_not equal(element.cache) # Should not be identical
    end

    it "should ignore cache and generate new representation if generation is explicitly forced" do
      element = Aef::Hosts::EmptyElement.new(:cache => "   \n")

      element.to_s(:force_generation => true).should == "\n"
    end
  end
end
