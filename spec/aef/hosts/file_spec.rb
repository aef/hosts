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
  
    it "should be allowed to be set" do
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
  
  describe "linebreak_encoding attribute" do
    it "should exist" do
      @file.should respond_to(:linebreak_encoding)
    end
    
    it "should be nil by default" do
      @file.linebreak_encoding.should be_nil
    end
    
    it "should be allowed to be set" do
      @file.should respond_to(:linebreak_encoding=)
    
      @file.linebreak_encoding = :unix
      
      @file.linebreak_encoding.should == :unix
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
        return_value = @file.read
      }.should change{ @file.entries.length }
      
      return_value.should == true
    end
    
    it "should allow the path attribute to be temporarily overridden" do
      @file.path = nil
      
      return_value = @file.read(@hosts_file)
      return_value.should == true
    end
    
    it "should correctly detect and set unix linebreak encoding if none is set" do
      @file.read
      
      @file.linebreak_encoding.should == :unix
    end
    
    it "should correctly detect and set windows linebreak encoding if none is set" do
      @file.path = fixtures_dir + 'windows_7_hosts'
      
      @file.read
      
      @file.linebreak_encoding.should == :windows
    end

    it "should correctly detect and fallback to the system linebreak encoding on windows and unix if the read file is mixed" do
      @file.path = fixtures_dir + 'hybrid_hosts'

      @file.read

      if Config::CONFIG['host_os'] =~ /mswin|mingw/
        @file.linebreak_encoding.should == :windows
      else
        @file.linebreak_encoding.should == :unix
      end
    end
    
    it "should not modify the linebreak encoding if already set" do
      @file.linebreak_encoding = :windows
      
      @file.read
      
      @file.linebreak_encoding.should == :windows
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
    
    it "should re-encode output if set to enforce linebreak encoding" do
      @file.linebreak_encoding = :unix
          
      generated_document = @file.to_s(:force_linebreak_encoding => true)
      
      generated_document.should == Aef::Linebreak.encode(@hosts_file.read, :unix)
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
    
    it "should allow the linebreak_encoding attribute to be temporarily overridden"
  end
end
