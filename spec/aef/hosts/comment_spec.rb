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

require 'spec_helper'

describe Aef::Hosts::Comment do
  before(:each) do
    @element = described_class.new('some comment')
  end

  describe "comment attribute" do
    it "should exist" do
      @element.should respond_to(:comment)
    end

    it "should be settable" do
      @element.should respond_to(:comment=)

      @element.comment = 'my comment'

      @element.comment.should == 'my comment'
    end

    it "should be settable through the constructor" do
      @element = Aef::Hosts::Comment.new('my comment')

      @element.comment.should == 'my comment'
    end
    
    it "should be a mandatory argument of the constructor" do
      lambda {
        @element = Aef::Hosts::Comment.new(nil)
      }.should raise_error(ArgumentError)
    end
    
    it "should flag the object as changed if modified" do
      lambda {
        @element.comment = 'my comment'
      }.should change{ @element.changed? }.from(false).to(true)
    end
  end
  
  describe "cache attribute" do
    it "should exist" do
      @element.should respond_to(:cache)
    end

    it "should be nil by default" do
      @element.cache.should be_nil
    end

    it "should not be allowed to be set" do
      @element.should_not respond_to(:cache=)
    end

    it "should be settable through the constructor" do
      element = Aef::Hosts::Comment.new('some comment', :cache => "   #some comment\n")

      element.cache.should == "   #some comment\n"
    end

    it "should be correctly reported as empty by cache_filled?" do
      @element.should respond_to(:cache_filled?)

      @element.cache_filled?.should be_false
    end

    it "should be correctly reported as filled by cache_filled?" do
      @element = Aef::Hosts::Comment.new('some comment', :cache => "   #some comment\n")

      @element.should respond_to(:cache_filled?)

      @element.cache_filled?.should be_true
    end

    it "should be invalidatable" do
      @element = Aef::Hosts::Entry.new('some comment', :cache => "   #some comment\n")

      @element.invalidate_cache

      @element.cache.should be_nil
    end
  end

  describe "string generation" do
    it "should generate a new representation if no cache is available" do
      @element = Aef::Hosts::Comment.new('some comment')

      @element.to_s.should == "#some comment\n"
    end

    it "should respond with a duplicate of the cached representation if cache is filled" do
      @element = Aef::Hosts::Comment.new('some comment',
        :cache   => "\t\t\t#some comment\n"
      )

      @element.to_s.should == "\t\t\t#some comment\n"
      @element.to_s.should_not equal(@element.cache) # Should not be identical
    end

    it "should ignore cache and generate a new representation if generation is explicitly forced" do
      @element = Aef::Hosts::Comment.new('some comment',
        :cache   => "\t\t\t#some comment\n"
      )

      @element.to_s(:force_generation => true).should == "#some comment\n"
    end
  end
end
