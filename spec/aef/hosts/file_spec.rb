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

describe Aef::Hosts::File do
  let(:hosts_file) { fixtures_dir + 'linux_hosts' }
  let(:file) { described_class.new }

  describe "path attribute" do
    it "should exist" do
      file.should respond_to(:path)
    end
    
    it "should be nil by default" do
      file.path.should be_nil
    end
  
    it "should be settable" do
      file.should respond_to(:path=)
  
      file.path = Pathname.pwd
  
      file.path.should == Pathname.pwd
    end
  
    it "should automatically convert strings to Pathname objects when set" do
      file.path = Dir.pwd

      file.path.should == Pathname.pwd
    end

    it "should be settable through the constructor" do
      file = Aef::Hosts::File.new(Pathname.pwd)

      file.path.should == Pathname.pwd
    end
  end
  
  describe "reading from file" do
    before(:each) do
      file.path = hosts_file
    end
  
    it "should be possible through the #read method" do
      file.should respond_to(:read)

      lambda {
        file.read.should == file
      }.should change{ file.elements.length }
    end
    
    it "should allow the path attribute to be temporarily overridden" do
      file.path = nil
      
      return_value = file.read(hosts_file)
      return_value.should == file
    end
  end
  
  describe "parsing" do
    before(:each) do
      file.path = hosts_file
    end
  
    it "should be possible through the #parse method" do
      file.should respond_to(:parse)

      lambda {
        file.parse(hosts_file.read).should == file
      }.should change{ file.elements.length }      
    end
    
  end
    
  describe "string generation" do
    it "should produce unchanged output if nothing changed" do
      file.path = hosts_file
      file.read
      
      file.to_s.should == hosts_file.read
    end
    
    it "should be able to re-encode the linebreaks of generated output" do
      hosts_file = fixtures_dir + 'windows_hosts'
      file.path = hosts_file
      file.read
      
      original_document = hosts_file.read
      
      file.to_s.should_not == original_document
      file.to_s(:linebreak_encoding => :windows).should == original_document
    end
  end

  describe "writing to file" do
    before(:each) do
      @dir = create_temp_dir
    end

    after(:each) do
      @dir.rmtree
    end

    it "should be possible through the #write method" do
      file.should respond_to(:write)

      result_file = @dir + 'hosts'
      data = hosts_file.read

      file.parse(data)
      file.path = result_file
      file.write
      
      result_file.read.should == data
    end
    
    it "should allow the path attribute to be temporarily overridden" do
      result_file = @dir + 'hosts'
      wrong_file  = @dir + 'wrong_file'
      data = hosts_file.read

      file.parse(data)
      file.path = wrong_file

      file.write(:path => result_file)

      result_file.read.should == data
    end
  end
end
