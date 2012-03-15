require 'spec_helper'

describe Aef::Hosts::Element do
  let(:element_subclass) { Class.new(Aef::Hosts::Element) }
  let(:element) { element_subclass.new }

  it "should complain about unimplemented #generate_string method" do
    lambda {
      element.to_s
    }.should raise_error(NotImplementedError)
  end
end
