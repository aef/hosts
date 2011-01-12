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

describe Aef::Hosts::File do
  before(:each) do
    @file = described_class.new
  end

  describe "path attribute" do
    it "should exist" do
      @file.should respond_to(:path)
    end
    
    it "should be nil by default" do
      @file.path.should be_nil
    end
  
    it "should be settable" do
      @file.should respond_to(:path=)
  
      @file.path = Pathname.pwd
  
      @file.path.should == Pathname.pwd
    end
  
    it "should automatically convert strings to Pathname objects when set" do
      @file.path = Dir.pwd

      @file.path.should == Pathname.pwd
    end

    it "should be settable through the constructor" do
      file = Aef::Hosts::File.new(Pathname.pwd)

      file.path.should == Pathname.pwd
    end
  end
  
  describe "reading" do
    before(:each) do
      @hosts_file = fixtures_dir + 'linux_hosts'
      @file.path = @hosts_file
    end
  
    it "should be possible through the #read method" do
      @file.should respond_to(:read)

      lambda {
        @file.read.should == true
      }.should change{ @file.elements.length }
      
    end
    
    it "should allow the path attribute to be temporarily overridden" do
      @file.path = nil
      
      return_value = @file.read(@hosts_file)
      return_value.should == true
    end
  end
    
  describe "generating" do
    before(:each) do
      @hosts_file = fixtures_dir + 'hybrid_hosts'
      @file.path = @hosts_file
      @file.read
    end

    it "should produce unchanged output if nothing changed" do
      @file.to_s.should == @hosts_file.read
    end
  end

  describe "writing" do
    before(:each) do
      @dir = create_temp_dir
    end

    after(:each) do
      @dir.rmtree
    end

    it "should be possible through the #write method" do
      @file.should respond_to(:write)
    end
    
    it "should allow the path attribute to be temporarily overridden"
  end
end
