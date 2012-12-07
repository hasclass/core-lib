require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Array#hash", ->
  it "returns the same fixnum for arrays with the same content", ->
    [].respond_to?(:hash).should == true

    [[], [1, 2, 3]].each do |ary|
      ary.hash.should == ary.dup.hash
      ary.hash.should be_kind_of(Fixnum)
  
  ruby_bug "#", "1.8.6.277", ->
    it "properly handles recursive arrays", ->
      empty = ArraySpecs.empty_recursive_array
      empty.hash.should be_kind_of(Integer)

      array = ArraySpecs.recursive_array
      array.hash.should be_kind_of(Integer)
  
  ruby_bug "redmine #1852", "1.9.1", ->
    it "returns the same hash for equal recursive arrays", ->
      rec = []; rec << rec
      rec.hash.should == [rec].hash
      rec.hash.should == [[rec]].hash
      # This is because rec.eql?([[rec]])
      # Remember that if two objects are eql?
      # then the need to have the same hash
      # Check the Array#eql? specs!
  
    it "returns the same hash for equal recursive arrays through hashes", ->
      h = {} ; rec = [h] ; h[:x] = rec
      rec.hash.should == [h].hash
      rec.hash.should == [{:x => rec}].hash
      # Like above, this is because rec.eql?([{:x => rec}])
  
  #  Too much of an implementation detail? -rue
  not_compliant_on :rubinius do
    it "calls to_int on result of calling hash on each element", ->
      ary = Array.new(5) do
        # Can't use should_receive here because it calls hash()
        obj = mock('0')
        def obj.hash()
          def self.to_int() freeze; 0 end
          return self
              obj
    
      ary.hash
      ary.each { |obj| obj.frozen?.should == true }

      hash = mock('1')
      hash.should_receive(:to_int).and_return(1.hash)

      obj = mock('@hash')
      obj.instance_variable_set(:@hash, hash)
      def obj.hash() @hash end

      [obj].hash.should == [1].hash
  
  it "ignores array class differences", ->
    ArraySpecs.MyArray[].hash.should == [].hash
    ArraySpecs.MyArray[1, 2].hash.should == [1, 2].hash

  it "returns same hash code for arrays with the same content", ->
    a = [1, 2, 3, 4]
    a.fill 'a', 0..3
    b = %w|a a a a|
    a.hash.should == b.hash

  it "returns the same value if arrays are #eql?", ->
    a = [1, 2, 3, 4]
    a.fill 'a', 0..3
    b = %w|a a a a|
    a.hash.should == b.hash
    a.should eql(b)
end
