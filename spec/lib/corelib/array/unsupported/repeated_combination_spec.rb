require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "1.9", ->
  describe "Array#repeated_combination", ->
    before :each do
      @array = [10, 11, 12]
  
    it "returns an enumerator when no block is provided", ->
      @array.repeated_combination(2).should be_an_instance_of(enumerator_class)
  
    it "returns self when a block is given", ->
      @array.repeated_combination(2){}.should equal(@array)
  
    it "yields nothing for negative length and return self", ->
      @array.repeated_combination(-1){ fail }.should equal(@array)
      @array.repeated_combination(-10){ fail }.should equal(@array)
  
    it "yields the expected repeated_combinations", ->
      @array.repeated_combination(2).to_a.sort.should == [[10, 10], [10, 11], [10, 12], [11, 11], [11, 12], [12, 12]]
      @array.repeated_combination(3).to_a.sort.should == [[10, 10, 10], [10, 10, 11], [10, 10, 12], [10, 11, 11], [10, 11, 12],
                                                          [10, 12, 12], [11, 11, 11], [11, 11, 12], [11, 12, 12], [12, 12, 12]]
  
    it "yields [] when length is 0", ->
      @array.repeated_combination(0).to_a.should == [[]] # one repeated_combination of length 0
      [].repeated_combination(0).to_a.should == [[]] # one repeated_combination of length 0
  
    it "yields nothing when the array is empty and num is non zero", ->
      [].repeated_combination(5).to_a.should == [] # one repeated_combination of length 0
  
    it "yields a partition consisting of only singletons", ->
      @array.repeated_combination(1).sort.to_a.should == [[10],[11],[12]]
  
    it "accepts sizes larger than the original array", ->
      @array.repeated_combination(4).to_a.sort.should ==
        [[10, 10, 10, 10], [10, 10, 10, 11], [10, 10, 10, 12],
         [10, 10, 11, 11], [10, 10, 11, 12], [10, 10, 12, 12],
         [10, 11, 11, 11], [10, 11, 11, 12], [10, 11, 12, 12],
         [10, 12, 12, 12], [11, 11, 11, 11], [11, 11, 11, 12],
         [11, 11, 12, 12], [11, 12, 12, 12], [12, 12, 12, 12]]
  
    it "generates from a defensive copy, ignoring mutations", ->
      accum = []
      @array.repeated_combination(2) do |x|
        accum << x
        @array[0] = 1
          accum.should == [[10, 10], [10, 11], [10, 12], [11, 11], [11, 12], [12, 12]]
