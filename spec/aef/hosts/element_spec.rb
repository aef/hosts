require 'spec_helper'

describe Aef::Hosts::Element do
  let(:element_subclass) { Class.new(Aef::Hosts::Element) }
  let(:element) { element_subclass.new }

  it "should complain about unimplemented #generate_string method" do
    expect {
      element.to_s
    }.to raise_error(NotImplementedError)
  end
end
