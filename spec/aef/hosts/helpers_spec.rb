require 'spec_helper'
require 'ostruct'

describe Aef::Hosts::Helpers do
  include Aef::Hosts::Helpers

  let(:model) {
    model = OpenStruct.new(
      :name => 'test',
      :cache_filled => true,
      :elements => ['fnord', 'eris']
    )

    def model.cache_filled?
      cache_filled
    end

    model
  }

  context "#validate_options" do
    it "should accept options with a subset of valid option keys" do
      options = {:valid1 => 123, :valid2 => 456} 

      lambda {
        validate_options(options, :valid1, :valid2, :valid3)
      }.should_not raise_error
    end

    it "should accept options with exactly the valid option keys" do
      options = {:valid1 => 123, :valid2 => 456, :valid3 => 789} 

      lambda {
        validate_options(options, :valid1, :valid2, :valid3)
      }.should_not raise_error
    end

    it "should deny options with invalid option keys" do
      options = {:valid1 => 123, :invalid => 'test'} 
  
      lambda {
        validate_options(options, :valid1, :valid2, :valid3)
      }.should raise_error(ArgumentError, "Invalid option keys: :invalid")
    end
  end

  context "#to_pathname" do
    it "should return nil when nil is given" do
      to_pathname(nil).should be_nil
    end

    it "should return a Pathname when a String is given" do
      to_pathname('abc/def').should eql Pathname.new('abc/def')
    end
    
    it "should return a Pathname when a Pathname is given" do
      to_pathname(Pathname.new('abc/def')).should eql Pathname.new('abc/def')
    end
  end

  context "generate_inspect" do
    it "should be able to render a minimal inspect output" do
      generate_inspect(model).should eql %{#<OpenStruct>}
    end

    it "should be able to render a normal attribute in inspect output" do
      generate_inspect(model, :name).should eql %{#<OpenStruct: name="test">}
    end

    it "should be able to render an attribute by custom String in inspect output" do
      generate_inspect(model, 'abc=123').should eql %{#<OpenStruct: abc=123>}
    end

    it "should be able to render a special cache attribute in inspect output" do
      generate_inspect(model, :cache).should eql %{#<OpenStruct: cached!>}
    end

    it "should not render a special cache attribute in inspect output if cache is not filled" do
      model.cache_filled = false
      generate_inspect(model, :cache).should eql %{#<OpenStruct>}
    end

    it "should be able to render elements in inspect output" do
      generate_inspect(model, :elements).should eql <<-STRING.chomp
#<OpenStruct: elements=[
  "fnord",
  "eris"
]>
      STRING
    end
  end

  context "generate_elements_partial" do
    it "should be able to render elements in inspect output" do
      generate_elements_partial(['fnord', 'eris']).should eql <<-STRING.chomp
elements=[
  "fnord",
  "eris"
]
      STRING
    end 
  end
end
