describe :array_length, :shared => true do
  it "returns the number of elements", ->
    [].send(@method).should == 0
    [1, 2, 3].send(@method).should == 3

  it "properly handles recursive arrays", ->
    ArraySpecs.empty_recursive_array.send(@method).should == 1
    ArraySpecs.recursive_array.send(@method).should == 8
end
