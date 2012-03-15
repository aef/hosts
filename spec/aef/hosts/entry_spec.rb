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

describe Aef::Hosts::Entry do
  let(:element) { described_class.new('192.168.0.1', 'somehost') }

  describe "address attribute" do
    it "should exist" do
      element.should respond_to(:address)
    end

    it "should be settable" do
      element.should respond_to(:address=)

      element.address = '127.0.0.1'

      element.address.should == '127.0.0.1'
    end

    it "should be settable through the constructor" do
      element = Aef::Hosts::Entry.new('127.0.0.1', 'localhost')

      element.address.should == '127.0.0.1'
    end
    
    it "should be a mandatory argument of the constructor" do
      lambda {
        element = Aef::Hosts::Entry.new(nil, 'localhost')
      }.should raise_error(ArgumentError)
    end
    
    it "should flag the object as changed if modified" do
      lambda {
        element.address = '127.0.0.1'
      }.should change{ element.changed? }.from(false).to(true)
    end
  end

  describe "name attribute" do
    it "should exist" do
      element.should respond_to(:name)
    end

    it "should be settable" do
      element.should respond_to(:name=)

      element.name = 'localhost'

      element.name.should == 'localhost'
    end

    it "should be settable through the constructor" do
      element = Aef::Hosts::Entry.new('127.0.0.1', 'localhost')

      element.name.should == 'localhost'
    end
    
    it "should be a mandatory argument of the constructor" do
      lambda {
        element = Aef::Hosts::Entry.new('127.0.0.1', nil)
      }.should raise_error(ArgumentError)
    end
    
    it "should flag the object as changed if modified" do
      lambda {
        element.name = 'localhost'
      }.should change{ element.changed? }.from(false).to(true)
    end
  end
  
  describe "comment attribute" do
    it "should exist" do
      element.should respond_to(:comment)
    end

    it "should be nil by default" do
      element.comment.should be_nil
    end

    it "should be settable" do
      element.should respond_to(:comment=)

      element.comment = 'my comment'

      element.comment.should == 'my comment'
    end

    it "should be settable through the constructor" do
      element = Aef::Hosts::Entry.new('127.0.0.1', 'localhost', :comment => 'my comment')

      element.comment.should == 'my comment'
    end
    
    it "should flag the object as changed if modified" do
      lambda {
        element.comment = 'my comment'
      }.should change{ element.changed? }.from(false).to(true)
    end
  end
  
  describe "aliases attribute" do
    it "should exist" do
      element.should respond_to(:aliases)
    end

    it "should be an empty array by default" do
      element.aliases.should == []
    end
    
    it "should be settable" do
      element.should respond_to(:aliases=)

      element.aliases = ['alias1', 'alias2']

      element.aliases.should == ['alias1', 'alias2']
    end

    it "should be settable through the constructor" do
      element = Aef::Hosts::Entry.new('127.0.0.1', 'localhost', :aliases => ['alias1', 'alias2'])

      element.aliases.should == ['alias1', 'alias2']
    end
    
    it "should flag the object as changed if modified" do
      lambda {
        element.aliases = ['alias1', 'alias2']
      }.should change{ element.changed? }.from(false).to(true)
    end
  end
  
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
      element = Aef::Hosts::Entry.new('127.0.0.1', 'localhost', :cache => "   \n")

      element.cache.should == "   \n"
    end

    it "should be correctly reported as empty by cache_filled?" do
      element.should respond_to(:cache_filled?)

      element.cache_filled?.should be_false
    end

    it "should be correctly reported as filled by cache_filled?" do
      element = Aef::Hosts::Entry.new('127.0.0.1', 'localhost', :cache => "   \n")

      element.should respond_to(:cache_filled?)

      element.cache_filled?.should be_true
    end

    it "should be invalidatable" do
      element = Aef::Hosts::Entry.new('127.0.0.1', 'localhost', :cache => "   \n")

      element.invalidate_cache!

      element.cache.should be_nil
    end
  end

  context "#inspect" do
    it "should be able to generate a debugging String" do
      element.inspect.should eql %{#<Aef::Hosts::Entry: address="192.168.0.1" name="somehost" aliases=[] comment=nil>}
    end

    it "should be able to generate a debugging String with aliases" do
      element.aliases << 'fnord'
      element.aliases << 'eris'
      element.inspect.should eql %{#<Aef::Hosts::Entry: address="192.168.0.1" name="somehost" aliases=["fnord", "eris"] comment=nil>}
    end

    it "should be able to generate a debugging String with comment" do
      element.comment = "This is not the host you're looking for"
      element.inspect.should eql %{#<Aef::Hosts::Entry: address="192.168.0.1" name="somehost" aliases=[] comment="This is not the host you're looking for">}
    end

    it "should be able to generate a debugging String with cache filled" do
      element = Aef::Hosts::Entry.new('192.168.0.1', 'somehost', :cache => 'Some cache...')
      element.inspect.should eql %{#<Aef::Hosts::Entry: address="192.168.0.1" name="somehost" aliases=[] comment=nil cached!>}
    end
  end

  describe "string generation" do
    it "should generate a new representation if no cache is available" do
      element = Aef::Hosts::Entry.new('127.0.0.1', 'localhost',
        :comment => 'my comment',
        :aliases => ['alias1', 'alias2']
      )

      element.to_s.should == "127.0.0.1 localhost alias1 alias2 #my comment\n"
    end

    it "should respond with a duplicate of the cached representation if cache is filled" do
      element = Aef::Hosts::Entry.new('127.0.0.1', 'localhost',
        :comment => 'my commenbt',
        :aliases => ['alias1', 'alias2'],
        :cache   => "127.0.0.1\tlocalhost\talias1\talias2\t#my comment\n"
      )

      element.to_s.should == "127.0.0.1\tlocalhost\talias1\talias2\t#my comment\n"
      element.to_s.should_not equal(element.cache) # Should not be identical
    end

    it "should ignore cache and generate a new representation if generation is explicitly forced" do
      element = Aef::Hosts::Entry.new('127.0.0.1', 'localhost',
        :comment => 'my comment',
        :aliases => ['alias1', 'alias2'],
        :cache   => "127.0.0.1\tlocalhost\talias1\talias2\t#my comment\n"
      )

      element.to_s(:force_generation => true).should == "127.0.0.1 localhost alias1 alias2 #my comment\n"
    end
  end
end
