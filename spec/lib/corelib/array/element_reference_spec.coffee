
# describe "Array.[]", ->
  # it "[] should return a new array populated with the given elements", ->
  #   array = Array[1, 'a', nil]
  #   array[0].should == 1
  #   array[1].should == 'a'
  #   array[2].should == nil

  # it "when applied to a primitive nested array, unpacks its elements into the containing array", ->
  #   Array[1, 2, *[3, 4, 5]].should == [1, 2, 3, 4, 5]

  # it "when applied to a nested referenced array, unpacks its elements into the containing array", ->
  #   splatted_array = Array[3, 4, 5]
  #   Array[1, 2, *splatted_array].should == [1, 2, 3, 4, 5]

  # ruby_version_is '1.9' do
  #   it "can unpack 2 or more nested referenced array", ->
  #     splatted_array = Array[3, 4, 5]
  #     splatted_array2 = Array[6, 7, 8]
  #     eval("Array[1, 2, *splatted_array, *splatted_array2]").should == [1, 2, 3, 4, 5, 6, 7, 8]

  #   it "constructs a nested Hash for tailing key-value pairs", ->
  #     eval(<<-EOS).should == [1, 2, { 3=> 4, 5 => 6 }]
  #       Array[1, 2, 3 => 4, 5 => 6]
  #     EOS

  # describe "with a subclass of Array", ->
  #   before :each do
  #     ScratchPad.clear

  #   it "returns an instance of the subclass", ->
  #     ArraySpecs.MyArray[1, 2, 3].should be_an_instance_of(ArraySpecs.MyArray)

  #   it "does not call #initialize on the subclass instance", ->
  #     ArraySpecs.MyArray[1, 2, 3].should == [1, 2, 3]
  #     ScratchPad.recorded.should be_nil

describe "Array#[]", ->
  #  it_behaves_like(:array_get, :[])

  it "returns the element at index with [index]", ->
    expect( R([ "a", "b", "c", "d", "e" ]).get(1) ).toEqual "b"

    a = R([1, 2, 3, 4])

    expect( a.get(0) ).toEqual 1
    expect( a.get(1) ).toEqual 2
    expect( a.get(2) ).toEqual 3
    expect( a.get(3) ).toEqual 4
    expect( a.get(4) ).toEqual null
    expect( a.get(10) ).toEqual null

    expect( a ).toEqual R([1, 2, 3, 4])

  it "returns the element at index from the end of the array with [-index]", ->
    expect( R([ "a", "b", "c", "d", "e" ]).get(-2) ).toEqual "d"

    a = R([1, 2, 3, 4])

    expect( a.get(-1) ).toEqual 4
    expect( a.get(-2) ).toEqual 3
    expect( a.get(-3) ).toEqual 2
    expect( a.get(-4) ).toEqual 1
    expect( a.get(-5) ).toEqual null
    expect( a.get(-10) ).toEqual null

    expect( a ).toEqual R([1, 2, 3, 4])

  it "return count elements starting from index with [index, count]", ->
    expect( R([ "a", "b", "c", "d", "e" ]).get(2, 3) ).toEqual R(["c", "d", "e"])

    a = R([1, 2, 3, 4])

    expect( a.get(0, 0) ).toEqual R([])
    expect( a.get(0, 1) ).toEqual R([1])
    expect( a.get(0, 2) ).toEqual R([1, 2])
    expect( a.get(0, 4) ).toEqual R([1, 2, 3, 4])
    expect( a.get(0, 6) ).toEqual R([1, 2, 3, 4])
    expect( a.get(0, -1) ).toEqual null
    expect( a.get(0, -2) ).toEqual null
    expect( a.get(0, -4) ).toEqual null

    expect( a.get(2, 0) ).toEqual R([])
    expect( a.get(2, 1) ).toEqual R([3])
    expect( a.get(2, 2) ).toEqual R([3, 4])
    expect( a.get(2, 4) ).toEqual R([3, 4])
    expect( a.get(2, -1) ).toEqual null

    expect( a.get(4, 0) ).toEqual R([])
    expect( a.get(4, 2) ).toEqual R([])
    expect( a.get(4, -1) ).toEqual null

    expect( a.get(5, 0) ).toEqual null
    expect( a.get(5, 2) ).toEqual null
    expect( a.get(5, -1) ).toEqual null

    expect( a.get(6, 0) ).toEqual null
    expect( a.get(6, 2) ).toEqual null
    expect( a.get(6, -1) ).toEqual null

    expect( a ).toEqual R([1, 2, 3, 4])

  it "returns count elements starting at index from the end of array with [-index, count]", ->
    expect( R([ "a", "b", "c", "d", "e" ]).get(-2, 2) ).toEqual R(["d", "e"])

    a = R([1, 2, 3, 4])

    expect( a.get(-1, 0) ).toEqual R([])
    expect( a.get(-1, 1) ).toEqual R([4])
    expect( a.get(-1, 2) ).toEqual R([4])
    expect( a.get(-1, -1) ).toEqual null

    expect( a.get(-2, 0) ).toEqual R([])
    expect( a.get(-2, 1) ).toEqual R([3])
    expect( a.get(-2, 2) ).toEqual R([3, 4])
    expect( a.get(-2, 4) ).toEqual R([3, 4])
    expect( a.get(-2, -1) ).toEqual null

    expect( a.get(-4, 0) ).toEqual R([])
    expect( a.get(-4, 1) ).toEqual R([1])
    expect( a.get(-4, 2) ).toEqual R([1, 2])
    expect( a.get(-4, 4) ).toEqual R([1, 2, 3, 4])
    expect( a.get(-4, 6) ).toEqual R([1, 2, 3, 4])
    expect( a.get(-4, -1) ).toEqual null

    expect( a.get(-5, 0) ).toEqual null
    expect( a.get(-5, 1) ).toEqual null
    expect( a.get(-5, 10) ).toEqual null
    expect( a.get(-5, -1) ).toEqual null

    expect( a ).toEqual R([1, 2, 3, 4])

  it "returns the first count elements with [0, count]", ->
    expect( R([ "a", "b", "c", "d", "e" ]).get(0, 3) ).toEqual R(["a", "b", "c"])

  it "returns the subarray which is independent to self with [index,count]", ->
    a = R([1, 2, 3])
    sub = a.get(1,2)
    sub.replace(['a', 'b'])
    expect( a ).toEqual R([1, 2, 3])

  it "tries to convert the passed argument to an Integer using #valueOf", ->
    obj =
      valueOf: -> 2

    a = R([1, 2, 3, 4])
    expect( a.get(obj) ).toEqual 3
    expect( a.get(obj, 1) ).toEqual R([3])
    expect( a.get(obj, obj) ).toEqual R([3, 4])
    expect( a.get(0, obj) ).toEqual R([1, 2])

  it "returns the elements specified by Range indexes with [m..n]", ->
    expect( R([ "a", "b", "c", "d", "e" ]).get(R.rng 1, 3)  ).toEqual R(["b", "c", "d"])
    expect( R([ "a", "b", "c", "d", "e" ]).get(R.rng 4, -1) ).toEqual R(['e'])
    expect( R([ "a", "b", "c", "d", "e" ]).get(R.rng 3, 3)  ).toEqual R(['d'])
    expect( R([ "a", "b", "c", "d", "e" ]).get(R.rng 3, -2) ).toEqual R(['d'])
    expect( R(['a']).get(R.rng 0, -1) ).toEqual R(['a'])

    a = R [1, 2, 3, 4]

    expect( a.get(R.rng 0, -10) ).toEqual R([])
    expect( a.get(R.rng 0, 0)   ).toEqual R([1])
    expect( a.get(R.rng 0, 1)   ).toEqual R([1, 2])
    expect( a.get(R.rng 0, 2)   ).toEqual R([1, 2, 3])
    expect( a.get(R.rng 0, 3)   ).toEqual R([1, 2, 3, 4])
    expect( a.get(R.rng 0, 4)   ).toEqual R([1, 2, 3, 4])
    expect( a.get(R.rng 0, 10)  ).toEqual R([1, 2, 3, 4])

    expect( a.get(R.rng 2, -10) ).toEqual R([])
    expect( a.get(R.rng 2, 0)   ).toEqual R([])
    expect( a.get(R.rng 2, 2)   ).toEqual R([3])
    expect( a.get(R.rng 2, 3)   ).toEqual R([3, 4])
    expect( a.get(R.rng 2, 4)   ).toEqual R([3, 4])

    expect( a.get(R.rng 3, 0)   ).toEqual R([])
    expect( a.get(R.rng 3, 3)   ).toEqual R([4])
    expect( a.get(R.rng 3, 4)   ).toEqual R([4])

    expect( a.get(R.rng 4, 0)   ).toEqual R([])
    expect( a.get(R.rng 4, 4)   ).toEqual R([])
    expect( a.get(R.rng 4, 5)   ).toEqual R([])

    expect( a.get(R.rng 5, 0)   ).toEqual R(null)
    expect( a.get(R.rng 5, 5)   ).toEqual R(null)
    expect( a.get(R.rng 5, 6)   ).toEqual R(null)

    expect( a ).toEqual R([1, 2, 3, 4])

  it "returns elements specified by Range indexes except the element at index n with [m...n]", ->
    expect( R([ "a", "b", "c", "d", "e" ]).get(R.rng 1, 3, true) ).toEqual R(["b", "c"])

    a = R [1, 2, 3, 4]

    expect( a.get(R.rng 0, -10, true) ).toEqual R([])
    expect( a.get(R.rng 0, 0, true)   ).toEqual R([])
    expect( a.get(R.rng 0, 1, true)   ).toEqual R([1])
    expect( a.get(R.rng 0, 2, true)   ).toEqual R([1, 2])
    expect( a.get(R.rng 0, 3, true)   ).toEqual R([1, 2, 3])
    expect( a.get(R.rng 0, 4, true)   ).toEqual R([1, 2, 3, 4])
    expect( a.get(R.rng 0, 10, true)  ).toEqual R([1, 2, 3, 4])

    expect( a.get(R.rng 2, -10, true) ).toEqual R([])
    expect( a.get(R.rng 2, 0, true)   ).toEqual R([])
    expect( a.get(R.rng 2, 2, true)   ).toEqual R([])
    expect( a.get(R.rng 2, 3, true)   ).toEqual R([3])
    expect( a.get(R.rng 2, 4, true)   ).toEqual R([3, 4])

    expect( a.get(R.rng 3, 0, true)   ).toEqual R([])
    expect( a.get(R.rng 3, 3, true)   ).toEqual R([])
    expect( a.get(R.rng 3, 4, true)   ).toEqual R([4])

    expect( a.get(R.rng 4, 0, true)   ).toEqual R([])
    expect( a.get(R.rng 4, 4, true)   ).toEqual R([])
    expect( a.get(R.rng 4, 5, true)   ).toEqual R([])

    expect( a.get(R.rng 5, 0, true)   ).toEqual null
    expect( a.get(R.rng 5, 5, true)   ).toEqual null
    expect( a.get(R.rng 5, 6, true)   ).toEqual null

    expect( a ).toEqual R([1, 2, 3, 4])

  it "returns elements that exist if range start is in the array but range end is not with [m..n]", ->
    expect( R([ "a", "b", "c", "d", "e" ]).get(R.rng 4, 7) ).toEqual R(["e"])

  it "accepts Range instances having a negative m and both signs for n with [m..n] and [m...n]", ->
    a = R([1, 2, 3, 4])

    expect( a.get(R.rng -1, -1) ).toEqual R([4])
    expect( a.get(R.rng -1, -1, true) ).toEqual R([])
    expect( a.get(R.rng -1, 3) ).toEqual R([4])
    expect( a.get(R.rng -1, 3, true) ).toEqual R([])
    expect( a.get(R.rng -1, 4) ).toEqual R([4])
    expect( a.get(R.rng -1, 4, true) ).toEqual R([4])
    expect( a.get(R.rng -1, 10) ).toEqual R([4])
    expect( a.get(R.rng -1, 10, true) ).toEqual R([4])
    expect( a.get(R.rng -1, 0) ).toEqual R([])
    expect( a.get(R.rng -1, -4) ).toEqual R([])
    expect( a.get(R.rng -1, -4, true) ).toEqual R([])
    expect( a.get(R.rng -1, -6) ).toEqual R([])
    expect( a.get(R.rng -1, -6, true) ).toEqual R([])

    expect( a.get(R.rng -2, -2) ).toEqual R([3])
    expect( a.get(R.rng -2, -2, true) ).toEqual R([])
    expect( a.get(R.rng -2, -1) ).toEqual R([3, 4])
    expect( a.get(R.rng -2, -1, true) ).toEqual R([3])
    expect( a.get(R.rng -2, 10) ).toEqual R([3, 4])
    expect( a.get(R.rng -2, 10, true) ).toEqual R([3, 4])

    expect( a.get(R.rng -4, -4) ).toEqual R([1])
    expect( a.get(R.rng -4, -2) ).toEqual R([1, 2, 3])
    expect( a.get(R.rng -4, -2, true) ).toEqual R([1, 2])
    expect( a.get(R.rng -4, -1) ).toEqual R([1, 2, 3, 4])
    expect( a.get(R.rng -4, -1, true) ).toEqual R([1, 2, 3])
    expect( a.get(R.rng -4, 3) ).toEqual R([1, 2, 3, 4])
    expect( a.get(R.rng -4, 3, true) ).toEqual R([1, 2, 3])
    expect( a.get(R.rng -4, 4) ).toEqual R([1, 2, 3, 4])
    expect( a.get(R.rng -4, 4, true) ).toEqual R([1, 2, 3, 4])
    expect( a.get(R.rng -4, 4, true) ).toEqual R([1, 2, 3, 4])
    expect( a.get(R.rng -4, 0) ).toEqual R([1])
    expect( a.get(R.rng -4, 0, true) ).toEqual R([])
    expect( a.get(R.rng -4, 1) ).toEqual R([1, 2])
    expect( a.get(R.rng -4, 1, true) ).toEqual R([1])

    expect( a.get(R.rng -5, -5) ).toEqual null
    expect( a.get(R.rng -5, -5, true) ).toEqual null
    expect( a.get(R.rng -5, -4) ).toEqual null
    expect( a.get(R.rng -5, -1) ).toEqual null
    expect( a.get(R.rng -5, 10) ).toEqual null

    expect( a ).toEqual R([1, 2, 3, 4])

  # it "returns the subarray which is independent to self with [m..n]", ->
  #   a = [1, 2, 3]
  #   sub = a.get(1..2)
  #   sub.replace([:a, :b])
  #   a.should == [1, 2, 3]

  # it "tries to convert Range elements to Integers using #valueOf with [m..n] and [m...n]", ->
  #   from = mock('from')
  #   to = mock('to')

  #   # So we can construct a range out of them...
  #   def from.<=>(o) 0 end
  #   def to.<=>(o) 0 end

  #   def from.valueOf() 1 end
  #   def to.valueOf() -2 end

  #   a = [1, 2, 3, 4]

  #   a.get(from..to).should == [2, 3]
  #   a.get(from...to).should == [2]
  #   a.get(1..0).should == []
  #   a.get(1...0).should == []

  #   expect( -> a.get("a" .. "b") ).toThrow(TypeError)
  #   expect( -> a.get("a" ... "b") ).toThrow(TypeError)
  #   expect( -> a.get(from .. "b") ).toThrow(TypeError)
  #   expect( -> a.get(from ... "b") ).toThrow(TypeError)

  # it "returns the same elements as [m..n] and [m...n] with Range subclasses", ->
  #   a = [1, 2, 3, 4]
  #   range_incl = ArraySpecs.MyRange.new(1, 2)
  #   range_excl = ArraySpecs.MyRange.new(-3, -1, true)

  #   a[range_incl].should == [2, 3]
  #   a[range_excl].should == [2, 3]

  it "returns nil for a requested index not in the array with [index]", ->
    expect( R([ "a", "b", "c", "d", "e" ]).get(5) ).toEqual null

  it "returns [] if the index is valid but length is zero with [index, length]", ->
    expect( R([ "a", "b", "c", "d", "e" ]).get(0, 0) ).toEqual R([])
    expect( R([ "a", "b", "c", "d", "e" ]).get(2, 0) ).toEqual R([])

  it "returns null if length is zero but index is invalid with [index, length]", ->
    expect( R([ "a", "b", "c", "d", "e" ]).get(100, 0) ).toEqual null
    expect( R([ "a", "b", "c", "d", "e" ]).get(-50, 0) ).toEqual null

  # This is by design. It is in the official documentation.
  it "returns [] if index == array.size with [index, length]", ->
    expect( R(['a', 'b', 'c', 'd', 'e']).get(5, 2) ).toEqual R([])

  it "returns nil if index > array.size with [index, length]", ->
    expect( R(['a', 'b', 'c', 'd', 'e']).get(6, 2) ).toEqual null

  it "returns null if length is negative with [index, length]", ->
    expect( R(['a', 'b', 'c', 'd', 'e']).get(3, -1) ).toEqual null
    expect( R(['a', 'b', 'c', 'd', 'e']).get(2, -2) ).toEqual null
    expect( R(['a', 'b', 'c', 'd', 'e']).get(1, -100) ).toEqual null

  it "returns nil if no requested index is in the array with [m..n]", ->
    expect( R( [ "a", "b", "c", "d", "e" ] ).get(R.rng 6,  10) ).toEqual null

  it "returns nil if range start is not in the array with [m..n]", ->
    expect( R( [ "a", "b", "c", "d", "e" ] ).get(R.rng -10, 2) ).toEqual null
    expect( R( [ "a", "b", "c", "d", "e" ] ).get(R.rng 10, 12) ).toEqual null

  it "returns an empty array when m == n with [m...n]", ->
    expect( R( [1, 2, 3, 4, 5] ).get(R.rng 1, 1, true) ).toEqual R([])

  it "returns an empty array with [0...0]", ->
    expect( R( [1, 2, 3, 4, 5] ).get(R.rng 0, 0, true) ).toEqual R([])

  it "returns a subarray where m, n negatives and m < n with [m..n]", ->
    expect( R( [ "a", "b", "c", "d", "e" ] ).get(R.rng -3, -2) ).toEqual R(["c", "d"])

  it "returns an array containing the first element with [0..0]", ->
    expect( R( [1, 2, 3, 4, 5] ).get(R.rng 0, 0) ).toEqual R([1])

  it "returns the entire array with [0..-1]", ->
    expect( R( [1, 2, 3, 4, 5] ).get(R.rng 0, -1) ).toEqual R([1, 2, 3, 4, 5])

  it "returns all but the last element with [0...-1]", ->
    expect( R( [1, 2, 3, 4, 5] ).get(R.rng 0, -1, true) ).toEqual R([1, 2, 3, 4])

  it "returns [3] for [2..-1] out of [1, 2, 3]", ->
    expect( R( [1,2,3] ).get(R.rng 2, -1) ).toEqual R([3])

  it "returns an empty array when m > n and m, n are positive with [m..n]", ->
    expect( R( [1, 2, 3, 4, 5] ).get(R.rng 3, 2) ).toEqual R([])

  it "returns an empty array when m > n and m, n are negative with [m..n]", ->
    expect( R( [1, 2, 3, 4, 5] ).get(R.rng -2, -3) ).toEqual R([])

  # it "does not expand array when the indices are outside of the array bounds", ->
  #   a = [1, 2]
  #   a.get(4) ).toEqual null
  #   a.should == [1, 2]
  #   a.get(4, 0).should == nil
  #   a.should == [1, 2]
  #   a.get(6, 1).should == nil
  #   a.should == [1, 2]
  #   a.get(8...8).should == nil
  #   a.should == [1, 2]
  #   a.get(10..10).should == nil
  #   a.should == [1, 2]

  xdescribe "with a subclass of Array", ->
  #   before :each do
  #     ScratchPad.clear

  #     @array = ArraySpecs.MyArray[1, 2, 3, 4, 5]

  #   it "returns a subclass instance with [n, m]", ->
  #     @array.get(0, 2).should be_an_instance_of(ArraySpecs.MyArray)

  #   it "returns a subclass instance with [-n, m]", ->
  #     @array.get(-3, 2).should be_an_instance_of(ArraySpecs.MyArray)

  #   it "returns a subclass instance with [n..m]", ->
  #     @array.get(1..3).should be_an_instance_of(ArraySpecs.MyArray)

  #   it "returns a subclass instance with [n...m]", ->
  #     @array.get(1...3).should be_an_instance_of(ArraySpecs.MyArray)

  #   it "returns a subclass instance with [-n..-m]", ->
  #     @array.get(-3..-1).should be_an_instance_of(ArraySpecs.MyArray)

  #   it "returns a subclass instance with [-n...-m]", ->
  #     @array.get(-3...-1).should be_an_instance_of(ArraySpecs.MyArray)

  #   it "returns an empty array when m == n with [m...n]", ->
  #     @array.get(1...1).should == []
  #     ScratchPad.recorded.should be_nil

  #   it "returns an empty array with [0...0]", ->
  #     @array.get(0...0).should == []
  #     ScratchPad.recorded.should be_nil

  #   it "returns an empty array when m > n and m, n are positive with [m..n]", ->
  #     @array.get(3..2).should == []
  #     ScratchPad.recorded.should be_nil

  #   it "returns an empty array when m > n and m, n are negative with [m..n]", ->
  #     @array.get(-2..-3).should == []
  #     ScratchPad.recorded.should be_nil

  #   it "returns [] if index == array.size with [index, length]", ->
  #     @array.get(5, 2).should == []
  #     ScratchPad.recorded.should be_nil

  #   it "returns [] if the index is valid but length is zero with [index, length]", ->
  #     @array.get(0, 0).should == []
  #     @array.get(2, 0).should == []
  #     ScratchPad.recorded.should be_nil

  #   it "does not call #initialize on the subclass instance", ->
  #     @array.get(0, 3).should == [1, 2, 3]
  #     ScratchPad.recorded.should be_nil

  # not_compliant_on :rubinius do
  #   it "raises a RangeError when the start index is out of range of Fixnum", ->
  #     array = [1, 2, 3, 4, 5, 6]
  #     obj = mock('large value')
  #     obj.should_receive(:valueOf).and_return(0x8000_0000_0000_0000_0000)
  #     expect( -> array.get(obj) ).toThrow(RangeError)

  #     obj = 8e19
  #     expect( -> array.get(obj) ).toThrow(RangeError)

  #   it "raises a RangeError when the length is out of range of Fixnum", ->
  #     array = [1, 2, 3, 4, 5, 6]
  #     obj = mock('large value')
  #     obj.should_receive(:valueOf).and_return(0x8000_0000_0000_0000_0000)
  #     expect( -> array.get(1, obj) ).toThrow(RangeError)

  #     obj = 8e19
  #     expect( -> array.get(1, obj) ).toThrow(RangeError)

  # deviates_on :rubinius do
  #   it "raises a TypeError when the start index is out of range of Fixnum", ->
  #     array = [1, 2, 3, 4, 5, 6]
  #     obj = mock('large value')
  #     obj.should_receive(:valueOf).and_return(0x8000_0000_0000_0000_0000)
  #     expect( -> array.get(obj) ).toThrow(TypeError)

  #     obj = 8e19
  #     expect( -> array.get(obj) ).toThrow(TypeError)

  #   it "raises a TypeError when the length is out of range of Fixnum", ->
  #     array = [1, 2, 3, 4, 5, 6]
  #     obj = mock('large value')
  #     obj.should_receive(:valueOf).and_return(0x8000_0000_0000_0000_0000)
  #     expect( -> array.get(1, obj) ).toThrow(TypeError)

  #     obj = 8e19
  #     expect( -> array.get(1, obj) ).toThrow(TypeError)
