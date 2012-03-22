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

describe Aef::Hosts::Section do
  let(:element) { described_class.new('some name') }

  describe "name attribute" do
    it "should exist" do
      element.should respond_to(:name)
    end

    it "should be settable" do
      element.should respond_to(:name=)

      element.name = 'demo section'

      element.name.should == 'demo section'
    end

    it "should be settable through the constructor" do
      element = Aef::Hosts::Section.new('demo section')

      element.name.should == 'demo section'
    end
    
    it "should be a mandatory argument of the constructor" do
      expect {
        element = Aef::Hosts::Section.new(nil)
      }.to raise_error(ArgumentError)
    end
    
    it "should flag the object as changed if modified" do
      element = Aef::Hosts::Section.new('some name', :cache => {
        :header => "# -----BEGIN SECTION some name-----    \n",
        :footer => "# -----END SECTION some name-----    \n"
      })

      expect {
        element.name = 'demo section'
      }.to change{ element.cache_filled? }.from(true).to(false)
    end
  end
  
  describe "elements attribute" do
    it "should exist" do
      element.should respond_to(:elements)
    end

    it "should be settable" do
      element.should respond_to(:elements=)

      element.elements = ['abc', 'def']

      element.elements.should eql ['abc', 'def']
    end

    it "should be settable through the constructor" do
      element = Aef::Hosts::Section.new('name', :elements => ['abc', 'def'])

      element.elements.should eql ['abc', 'def']
    end
    
    it "should flag the object as changed if modified" do
      child_element = 'abc'
      element = Aef::Hosts::Section.new('some name', :cache => {
        :header => "# -----BEGIN SECTION some name-----    \n",
        :footer => "# -----END SECTION some name-----    \n"
      }, :elements => [child_element])

      child_element.should_not_receive(:invalidate_cache!)

      expect {
        element.elements = [child_element, 'def']
      }.to change{ element.cache_filled? }.from(true).to(false)
    end
  end
  
  describe "cache attribute" do
    it "should exist" do
      element.should respond_to(:cache)
    end

    it "should be nil by default" do
      element.cache.should == {:footer => nil, :header => nil}
    end

    it "should not be allowed to be set" do
      element.should_not respond_to(:cache=)
    end

    it "should be settable through the constructor" do
      element = Aef::Hosts::Section.new('demo section', :cache => {
          :header => "# -----BEGIN SECTION demo section-----    \n",
          :footer => "# -----END SECTION demo section-----\t\t\t\n"
      })
      
      element.cache.should == {
        :header => "# -----BEGIN SECTION demo section-----    \n",
        :footer => "# -----END SECTION demo section-----\t\t\t\n"
      }
    end

    it "should be correctly reported as empty by cache_filled?" do
      element.should respond_to(:cache_filled?)

      element.cache_filled?.should be_false
    end

    it "should be correctly reported as filled by cache_filled?" do
      element = Aef::Hosts::Section.new('demo section', :cache => {
          :header => "# -----BEGIN SECTION demo section-----    \n",
          :footer => "# -----END SECTION demo section-----\t\t\t\n"
      })
      
      element.should respond_to(:cache_filled?)

      element.cache_filled?.should be_true
    end

    it "should be invalidatable" do
      element = Aef::Hosts::Section.new('demo section', :cache => {
          :header => "# -----BEGIN SECTION demo section-----    \n",
          :footer => "# -----END SECTION demo section-----\t\t\t\n"
      })

      element.invalidate_cache!

      element.cache[:header].should be_nil
      element.cache[:footer].should be_nil
    end
  end

  context "#invalidate_cache!" do
    it "should clear the cache of the section and its elements" do
      child_a = 'markov'
      child_b = 'chainey'

      child_a.should_receive(:invalidate_cache!)
      child_b.should_receive(:invalidate_cache!)

      element.elements << child_a
      element.elements << child_b

      element.invalidate_cache!
    end

    it "should clear the cache of the section only if :only_section is set" do
      child_a = 'markov'
      child_b = 'chainey'

      child_a.should_not_receive(:invalidate_cache!)
      child_b.should_not_receive(:invalidate_cache!)

      element.elements << child_a
      element.elements << child_b

      element.invalidate_cache!(:only_section => true)
    end
  end

  context "#inspect" do
    it "should be able to generate a debugging String" do
      element.inspect.should eql %{#<Aef::Hosts::Section: name="some name" elements=[]>}
    end

    it "should be able to generate a debugging String with elements" do
      element.elements << 'fnord'
      element.elements << 'eris'
      element.inspect.should eql <<-STRING.chomp
#<Aef::Hosts::Section: name="some name" elements=[
  "fnord",
  "eris"
]>
      STRING
    end

    it "should be able to generate a debugging String with cache filled" do
      element = Aef::Hosts::Section.new('demo section', :cache => {:header => 'abc', :footer => 'xyz'})
      element.inspect.should eql %{#<Aef::Hosts::Section: name="demo section" cached! elements=[]>}
    end
  end

  describe "string generation" do
    before(:all) do
      class Aef::Hosts::ChildElement < Aef::Hosts::Element
        def generate_string(options = {})
          "uncached element representation\n"
        end
        
        def cache=(cache)
          @cache = cache
        end
      end
    end
  
    it "should generate a new representation if no cache is available" do
      element = Aef::Hosts::Section.new('demo section')

      element.to_s.should == <<-EOS
# -----BEGIN SECTION demo section-----
# -----END SECTION demo section-----
      EOS
    end
    
    it "should respond with a duplicate of the cached representation if cache is filled" do
      element = Aef::Hosts::Section.new('demo section', :cache => {
        :header => "# -----BEGIN SECTION demo section-----    \n",
        :footer => "# -----END SECTION demo section-----    \n"
      })

      element.to_s.should == <<-EOS
# -----BEGIN SECTION demo section-----    
# -----END SECTION demo section-----    
      EOS

      # Should not be identical
      element.to_s.should_not equal(element.cache[:footer])
      element.to_s.should_not equal(element.cache[:header])
    end

    it "should respond with a duplicate of the cached representation if cache is filled" do
      element = Aef::Hosts::Section.new('demo section', :cache => {
        :header => "# -----BEGIN SECTION demo section-----    \n",
        :footer => "# -----END SECTION demo section-----    \n"
      })

      element.to_s(:force_generation => true).should == <<-EOS
# -----BEGIN SECTION demo section-----
# -----END SECTION demo section-----
      EOS
    end
    
    it "should correctly display including elements" do
      sub_element_without_cache    = Aef::Hosts::ChildElement.new
      sub_element_with_cache       = Aef::Hosts::ChildElement.new
      sub_element_with_cache.cache = "cached element representation\n"
    
      element = Aef::Hosts::Section.new('demo section',
        :elements => [
          sub_element_with_cache,
          sub_element_without_cache
        ],
        :cache => {
          :header => "# -----BEGIN SECTION demo section-----    \n",
          :footer => "# -----END SECTION demo section-----    \n"
        }
      )

      element.to_s.should == <<-EOS
# -----BEGIN SECTION demo section-----    
cached element representation
uncached element representation
# -----END SECTION demo section-----    
      EOS
    end

    it "should correctly display including elements with forced generation" do
      sub_element_without_cache    = Aef::Hosts::ChildElement.new
      sub_element_with_cache       = Aef::Hosts::ChildElement.new
      sub_element_with_cache.cache = "cached element representation\n"
    
      element = Aef::Hosts::Section.new('demo section',
        :elements => [
          sub_element_with_cache,
          sub_element_without_cache
        ],
        :cache => {
          :header => "# -----BEGIN SECTION demo section-----    \n",
          :footer => "# -----END SECTION demo section-----    \n"
        }
      )

      element.to_s(:force_generation => true).should == <<-EOS
# -----BEGIN SECTION demo section-----
uncached element representation
uncached element representation
# -----END SECTION demo section-----
      EOS
    end
  end
end
