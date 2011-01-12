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

describe Aef::Hosts::Section do
  before(:each) do
    @element = described_class.new('some name')
  end

  describe "name attribute" do
    it "should exist" do
      @element.should respond_to(:name)
    end

    it "should be settable" do
      @element.should respond_to(:name=)

      @element.name = 'demo section'

      @element.name.should == 'demo section'
    end

    it "should be settable through the constructor" do
      @element = Aef::Hosts::Section.new('demo section')

      @element.name.should == 'demo section'
    end
    
    it "should be a mandatory argument of the constructor" do
      lambda {
        @element = Aef::Hosts::Section.new(nil)
      }.should raise_error(ArgumentError)
    end
    
    it "should flag the object as changed if modified" do
      lambda {
        @element.name = 'demo section'
      }.should change{ @element.changed? }.from(false).to(true)
    end
  end
  
  describe "cache attribute" do
    it "should exist" do
      @element.should respond_to(:cache)
    end

    it "should be nil by default" do
      @element.cache.should == {:footer => nil, :header => nil}
    end

    it "should not be allowed to be set" do
      @element.should_not respond_to(:cache=)
    end

    it "should be settable through the constructor" do
      @element = Aef::Hosts::Section.new('demo section', :cache => {
          :header => "# -----BEGIN SECTION demo section-----    \n",
          :footer => "# -----END SECTION demo section-----\t\t\t\n"
      })
      
      @element.cache.should == {
        :header => "# -----BEGIN SECTION demo section-----    \n",
        :footer => "# -----END SECTION demo section-----\t\t\t\n"
      }
    end

    it "should be correctly reported as empty by cache_filled?" do
      @element.should respond_to(:cache_filled?)

      @element.cache_filled?.should be_false
    end

    it "should be correctly reported as filled by cache_filled?" do
      @element = Aef::Hosts::Section.new('demo section', :cache => {
          :header => "# -----BEGIN SECTION demo section-----    \n",
          :footer => "# -----END SECTION demo section-----\t\t\t\n"
      })
      
      @element.should respond_to(:cache_filled?)

      @element.cache_filled?.should be_true
    end

    it "should be invalidatable" do
      element = Aef::Hosts::Section.new('demo section', :cache => {
          :header => "# -----BEGIN SECTION demo section-----    \n",
          :footer => "# -----END SECTION demo section-----\t\t\t\n"
      })

      @element.invalidate_cache

      @element.cache.should be_nil
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
      @element = Aef::Hosts::Section.new('demo section')

      @element.to_s.should == <<-EOS
# -----BEGIN SECTION demo section-----
# -----END SECTION demo section-----
      EOS
    end
    
    it "should respond with a duplicate of the cached representation if cache is filled" do
      @element = Aef::Hosts::Section.new('demo section', :cache => {
        :header => "# -----BEGIN SECTION demo section-----    \n",
        :footer => "# -----END SECTION demo section-----    \n"
      })

      @element.to_s.should == <<-EOS
# -----BEGIN SECTION demo section-----    
# -----END SECTION demo section-----    
      EOS

      # Should not be identical
      @element.to_s.should_not equal(@element.cache[:footer])
      @element.to_s.should_not equal(@element.cache[:header])
    end

    it "should respond with a duplicate of the cached representation if cache is filled" do
      @element = Aef::Hosts::Section.new('demo section', :cache => {
        :header => "# -----BEGIN SECTION demo section-----    \n",
        :footer => "# -----END SECTION demo section-----    \n"
      })

      @element.to_s(:force_generation => true).should == <<-EOS
# -----BEGIN SECTION demo section-----
# -----END SECTION demo section-----
      EOS
    end
    
    it "should correctly display including elements" do
      sub_element_without_cache    = Aef::Hosts::ChildElement.new
      sub_element_with_cache       = Aef::Hosts::ChildElement.new
      sub_element_with_cache.cache = "cached element representation\n"
    
      @element = Aef::Hosts::Section.new('demo section',
        :elements => [
          sub_element_with_cache,
          sub_element_without_cache
        ],
        :cache => {
          :header => "# -----BEGIN SECTION demo section-----    \n",
          :footer => "# -----END SECTION demo section-----    \n"
        }
      )

      @element.to_s.should == <<-EOS
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
    
      @element = Aef::Hosts::Section.new('demo section',
        :elements => [
          sub_element_with_cache,
          sub_element_without_cache
        ],
        :cache => {
          :header => "# -----BEGIN SECTION demo section-----    \n",
          :footer => "# -----END SECTION demo section-----    \n"
        }
      )

      @element.to_s(:force_generation => true).should == <<-EOS
# -----BEGIN SECTION demo section-----
uncached element representation
uncached element representation
# -----END SECTION demo section-----
      EOS
    end
  end
end
