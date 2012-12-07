require File.expand_path('../../../spec_helper', __FILE__)

describe "Array.allocate", ->
  it "returns an instance of Array", ->
    ary = Array.allocate
    ary.should be_kind_of(Array)

  it "returns a fully-formed instance of Array", ->
    ary = Array.allocate
    ary.size.should == 0
    ary << 1
    ary.should == [1]

  it "does not accept any arguments", ->
    expect( -> Array.allocate(1) ).toThrow(ArgumentError)
end
