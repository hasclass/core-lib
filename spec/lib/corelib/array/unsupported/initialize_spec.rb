require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Array#initialize", ->
  before :each do
    ScratchPad.clear

  it "is private", ->
    Array.should have_private_instance_method("initialize")

  it "is called on subclasses", ->
    b = ArraySpecs.SubArray.new :size_or_array, :obj

    b.should == []
    ScratchPad.recorded.should == [:size_or_array, :obj]

  it "preserves the object's identity even when changing its value", ->
    a = [1, 2, 3]
    a.send(:initialize).should equal(a)
    a.should_not == [1, 2, 3]

  it "raise an ArgumentError if passed 3 or more arguments", ->
    lambda do
      [1, 2].send :initialize, 1, 'x', true
    end.should raise_error(ArgumentError)
    lambda do
      [1, 2].send(:initialize, 1, 'x', true) {}
    end.should raise_error(ArgumentError)

  ruby_version_is '' ... '1.9' do
    it "raises a TypeError on frozen arrays even if the array would not be modified", ->
      lambda do
        ArraySpecs.frozen_array.send :initialize
      end.should raise_error(TypeError)
      lambda do
        ArraySpecs.frozen_array.send :initialize, ArraySpecs.frozen_array
      end.should raise_error(TypeError)
  
  ruby_version_is '1.9' do
    it "raises a RuntimeError on frozen arrays", ->
      lambda do
        ArraySpecs.frozen_array.send :initialize
      end.should raise_error(RuntimeError)
      lambda do
        ArraySpecs.frozen_array.send :initialize, ArraySpecs.frozen_array
      end.should raise_error(RuntimeError)

describe "Array#initialize with no arguments", ->
  it "makes the array empty", ->
    [1, 2, 3].send(:initialize).should be_empty

  it "does not use the given block", ->
    lambda{ [1, 2, 3].send(:initialize) { raise } }.should_not raise_error
end

describe "Array#initialize with (array)", ->
  it "replaces self with the other array", ->
    b = [4, 5, 6]
    [1, 2, 3].send(:initialize, b).should == b

  it "does not use the given block", ->
    lambda{ [1, 2, 3].send(:initialize) { raise } }.should_not raise_error

  it "calls #to_ary to convert the value to an array", ->
    a = mock("array")
    a.should_receive(:to_ary).and_return([1, 2])
    a.should_not_receive(:to_int)
    [].send(:initialize, a).should == [1, 2]

  it "does not call #to_ary on instances of Array or subclasses of Array", ->
    a = [1, 2]
    a.should_not_receive(:to_ary)
    [].send(:initialize, a).should == a

  it "raises a TypeError if an Array type argument and a default object", ->
    expect( -> [].send(:initialize, [1, 2], 1) ).toThrow(TypeError)
end

describe "Array#initialize with (size, object=nil)", ->
  it "sets the array to size and fills with the object", ->
    a = []
    obj = [3]
    a.send(:initialize, 2, obj).should == [obj, obj]
    a[0].should equal(obj)
    a[1].should equal(obj)

  it "sets the array to size and fills with nil when object is omitted", ->
    [].send(:initialize, 3).should == [nil, nil, nil]

  it "raises an ArgumentError if size is negative", ->
    expect( -> [].send(:initialize, -1, :a) ).toThrow(ArgumentError)
    expect( -> [].send(:initialize, -1) ).toThrow(ArgumentError)

  platform_is :wordsize => 32 do
    it "raises an ArgumentError if size is too large", ->
      max_size = ArraySpecs.max_32bit_size
      expect( -> [].send(:initialize, max_size + 1) ).toThrow(ArgumentError)
  
  platform_is :wordsize => 64 do
    it "raises an ArgumentError if size is too large", ->
      max_size = ArraySpecs.max_64bit_size
      expect( -> [].send(:initialize, max_size + 1) ).toThrow(ArgumentError)
  
  it "calls #to_int to convert the size argument to an Integer when object is given", ->
    obj = mock('1')
    obj.should_receive(:to_int).and_return(1)
    [].send(:initialize, obj, :a).should == [:a]

  it "calls #to_int to convert the size argument to an Integer when object is not given", ->
    obj = mock('1')
    obj.should_receive(:to_int).and_return(1)
    [].send(:initialize, obj).should == [nil]

  it "raises a TypeError if the size argument is not an Integer type", ->
    obj = mock('nonnumeric')
    obj.stub!(:to_ary).and_return([1, 2])
    lambda{ [].send(:initialize, obj, :a) ).toThrow(TypeError)

  it "yields the index of the element and sets the element to the value of the block", ->
    [].send(:initialize, 3) { |i| i.to_s }.should == ['0', '1', '2']

  it "uses the block value instead of using the default value", ->
    [].send(:initialize, 3, :obj) { |i| i.to_s }.should == ['0', '1', '2']

  it "returns the value passed to break", ->
    [].send(:initialize, 3) { break :a }.should == :a

  it "sets the array to the values returned by the block before break is executed", ->
    a = [1, 2, 3]
    a.send(:initialize, 3) do |i|
      break if i == 2
      i.to_s
  
    a.should == ['0', '1']
end
