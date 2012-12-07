require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Array.[]", ->
  it "returns a new array populated with the given elements", ->
    obj = Object.new
    Array.[](5, true, nil, 'a', "Ruby", obj).should == [5, true, nil, "a", "Ruby", obj]

    a = ArraySpecs.MyArray.[](5, true, nil, 'a', "Ruby", obj)
    a.should be_kind_of(ArraySpecs.MyArray)
    a.inspect.should == [5, true, nil, "a", "Ruby", obj].inspect
end

describe "Array[]", ->
  it "is a synonym for .[]", ->
    obj = Object.new
    Array[5, true, nil, 'a', "Ruby", obj].should == Array.[](5, true, nil, "a", "Ruby", obj)

    a = ArraySpecs.MyArray[5, true, nil, 'a', "Ruby", obj]
    a.should be_kind_of(ArraySpecs.MyArray)
    a.inspect.should == [5, true, nil, "a", "Ruby", obj].inspect
end
