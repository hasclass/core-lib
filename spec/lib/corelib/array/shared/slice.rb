describe :array_slice, :shared => true do
  it "returns the element at index with [index]", ->
    [ "a", "b", "c", "d", "e" ].send(@method, 1).should == "b"

    a = [1, 2, 3, 4]

    a.send(@method, 0).should == 1
    a.send(@method, 1).should == 2
    a.send(@method, 2).should == 3
    a.send(@method, 3).should == 4
    a.send(@method, 4).should == nil
    a.send(@method, 10).should == nil

    a.should == [1, 2, 3, 4]

  it "returns the element at index from the end of the array with [-index]", ->
    [ "a", "b", "c", "d", "e" ].send(@method, -2).should == "d"

    a = [1, 2, 3, 4]

    a.send(@method, -1).should == 4
    a.send(@method, -2).should == 3
    a.send(@method, -3).should == 2
    a.send(@method, -4).should == 1
    a.send(@method, -5).should == nil
    a.send(@method, -10).should == nil

    a.should == [1, 2, 3, 4]

  it "return count elements starting from index with [index, count]", ->
    [ "a", "b", "c", "d", "e" ].send(@method, 2, 3).should == ["c", "d", "e"]

    a = [1, 2, 3, 4]

    a.send(@method, 0, 0).should == []
    a.send(@method, 0, 1).should == [1]
    a.send(@method, 0, 2).should == [1, 2]
    a.send(@method, 0, 4).should == [1, 2, 3, 4]
    a.send(@method, 0, 6).should == [1, 2, 3, 4]
    a.send(@method, 0, -1).should == nil
    a.send(@method, 0, -2).should == nil
    a.send(@method, 0, -4).should == nil

    a.send(@method, 2, 0).should == []
    a.send(@method, 2, 1).should == [3]
    a.send(@method, 2, 2).should == [3, 4]
    a.send(@method, 2, 4).should == [3, 4]
    a.send(@method, 2, -1).should == nil

    a.send(@method, 4, 0).should == []
    a.send(@method, 4, 2).should == []
    a.send(@method, 4, -1).should == nil

    a.send(@method, 5, 0).should == nil
    a.send(@method, 5, 2).should == nil
    a.send(@method, 5, -1).should == nil

    a.send(@method, 6, 0).should == nil
    a.send(@method, 6, 2).should == nil
    a.send(@method, 6, -1).should == nil

    a.should == [1, 2, 3, 4]

  it "returns count elements starting at index from the end of array with [-index, count]", ->
    [ "a", "b", "c", "d", "e" ].send(@method, -2, 2).should == ["d", "e"]

    a = [1, 2, 3, 4]

    a.send(@method, -1, 0).should == []
    a.send(@method, -1, 1).should == [4]
    a.send(@method, -1, 2).should == [4]
    a.send(@method, -1, -1).should == nil

    a.send(@method, -2, 0).should == []
    a.send(@method, -2, 1).should == [3]
    a.send(@method, -2, 2).should == [3, 4]
    a.send(@method, -2, 4).should == [3, 4]
    a.send(@method, -2, -1).should == nil

    a.send(@method, -4, 0).should == []
    a.send(@method, -4, 1).should == [1]
    a.send(@method, -4, 2).should == [1, 2]
    a.send(@method, -4, 4).should == [1, 2, 3, 4]
    a.send(@method, -4, 6).should == [1, 2, 3, 4]
    a.send(@method, -4, -1).should == nil

    a.send(@method, -5, 0).should == nil
    a.send(@method, -5, 1).should == nil
    a.send(@method, -5, 10).should == nil
    a.send(@method, -5, -1).should == nil

    a.should == [1, 2, 3, 4]

  it "returns the first count elements with [0, count]", ->
    [ "a", "b", "c", "d", "e" ].send(@method, 0, 3).should == ["a", "b", "c"]

  it "returns the subarray which is independent to self with [index,count]", ->
    a = [1, 2, 3]
    sub = a.send(@method, 1,2)
    sub.replace([:a, :b])
    a.should == [1, 2, 3]

  it "tries to convert the passed argument to an Integer using #to_int", ->
    obj = mock('to_int')
    obj.stub!(:to_int).and_return(2)

    a = [1, 2, 3, 4]
    a.send(@method, obj).should == 3
    a.send(@method, obj, 1).should == [3]
    a.send(@method, obj, obj).should == [3, 4]
    a.send(@method, 0, obj).should == [1, 2]

  it "returns the elements specified by Range indexes with [m..n]", ->
    [ "a", "b", "c", "d", "e" ].send(@method, 1..3).should == ["b", "c", "d"]
    [ "a", "b", "c", "d", "e" ].send(@method, 4..-1).should == ['e']
    [ "a", "b", "c", "d", "e" ].send(@method, 3..3).should == ['d']
    [ "a", "b", "c", "d", "e" ].send(@method, 3..-2).should == ['d']
    ['a'].send(@method, 0..-1).should == ['a']

    a = [1, 2, 3, 4]

    a.send(@method, 0..-10).should == []
    a.send(@method, 0..0).should == [1]
    a.send(@method, 0..1).should == [1, 2]
    a.send(@method, 0..2).should == [1, 2, 3]
    a.send(@method, 0..3).should == [1, 2, 3, 4]
    a.send(@method, 0..4).should == [1, 2, 3, 4]
    a.send(@method, 0..10).should == [1, 2, 3, 4]

    a.send(@method, 2..-10).should == []
    a.send(@method, 2..0).should == []
    a.send(@method, 2..2).should == [3]
    a.send(@method, 2..3).should == [3, 4]
    a.send(@method, 2..4).should == [3, 4]

    a.send(@method, 3..0).should == []
    a.send(@method, 3..3).should == [4]
    a.send(@method, 3..4).should == [4]

    a.send(@method, 4..0).should == []
    a.send(@method, 4..4).should == []
    a.send(@method, 4..5).should == []

    a.send(@method, 5..0).should == nil
    a.send(@method, 5..5).should == nil
    a.send(@method, 5..6).should == nil

    a.should == [1, 2, 3, 4]

  it "returns elements specified by Range indexes except the element at index n with [m...n]", ->
    [ "a", "b", "c", "d", "e" ].send(@method, 1...3).should == ["b", "c"]

    a = [1, 2, 3, 4]

    a.send(@method, 0...-10).should == []
    a.send(@method, 0...0).should == []
    a.send(@method, 0...1).should == [1]
    a.send(@method, 0...2).should == [1, 2]
    a.send(@method, 0...3).should == [1, 2, 3]
    a.send(@method, 0...4).should == [1, 2, 3, 4]
    a.send(@method, 0...10).should == [1, 2, 3, 4]

    a.send(@method, 2...-10).should == []
    a.send(@method, 2...0).should == []
    a.send(@method, 2...2).should == []
    a.send(@method, 2...3).should == [3]
    a.send(@method, 2...4).should == [3, 4]

    a.send(@method, 3...0).should == []
    a.send(@method, 3...3).should == []
    a.send(@method, 3...4).should == [4]

    a.send(@method, 4...0).should == []
    a.send(@method, 4...4).should == []
    a.send(@method, 4...5).should == []

    a.send(@method, 5...0).should == nil
    a.send(@method, 5...5).should == nil
    a.send(@method, 5...6).should == nil

    a.should == [1, 2, 3, 4]

  it "returns elements that exist if range start is in the array but range end is not with [m..n]", ->
    [ "a", "b", "c", "d", "e" ].send(@method, 4..7).should == ["e"]

  it "accepts Range instances having a negative m and both signs for n with [m..n] and [m...n]", ->
    a = [1, 2, 3, 4]

    a.send(@method, -1..-1).should == [4]
    a.send(@method, -1...-1).should == []
    a.send(@method, -1..3).should == [4]
    a.send(@method, -1...3).should == []
    a.send(@method, -1..4).should == [4]
    a.send(@method, -1...4).should == [4]
    a.send(@method, -1..10).should == [4]
    a.send(@method, -1...10).should == [4]
    a.send(@method, -1..0).should == []
    a.send(@method, -1..-4).should == []
    a.send(@method, -1...-4).should == []
    a.send(@method, -1..-6).should == []
    a.send(@method, -1...-6).should == []

    a.send(@method, -2..-2).should == [3]
    a.send(@method, -2...-2).should == []
    a.send(@method, -2..-1).should == [3, 4]
    a.send(@method, -2...-1).should == [3]
    a.send(@method, -2..10).should == [3, 4]
    a.send(@method, -2...10).should == [3, 4]

    a.send(@method, -4..-4).should == [1]
    a.send(@method, -4..-2).should == [1, 2, 3]
    a.send(@method, -4...-2).should == [1, 2]
    a.send(@method, -4..-1).should == [1, 2, 3, 4]
    a.send(@method, -4...-1).should == [1, 2, 3]
    a.send(@method, -4..3).should == [1, 2, 3, 4]
    a.send(@method, -4...3).should == [1, 2, 3]
    a.send(@method, -4..4).should == [1, 2, 3, 4]
    a.send(@method, -4...4).should == [1, 2, 3, 4]
    a.send(@method, -4...4).should == [1, 2, 3, 4]
    a.send(@method, -4..0).should == [1]
    a.send(@method, -4...0).should == []
    a.send(@method, -4..1).should == [1, 2]
    a.send(@method, -4...1).should == [1]

    a.send(@method, -5..-5).should == nil
    a.send(@method, -5...-5).should == nil
    a.send(@method, -5..-4).should == nil
    a.send(@method, -5..-1).should == nil
    a.send(@method, -5..10).should == nil

    a.should == [1, 2, 3, 4]

  it "returns the subarray which is independent to self with [m..n]", ->
    a = [1, 2, 3]
    sub = a.send(@method, 1..2)
    sub.replace([:a, :b])
    a.should == [1, 2, 3]

  it "tries to convert Range elements to Integers using #to_int with [m..n] and [m...n]", ->
    from = mock('from')
    to = mock('to')

    # So we can construct a range out of them...
    def from.<=>(o) 0 end
    def to.<=>(o) 0 end

    def from.to_int() 1 end
    def to.to_int() -2 end

    a = [1, 2, 3, 4]

    a.send(@method, from..to).should == [2, 3]
    a.send(@method, from...to).should == [2]
    a.send(@method, 1..0).should == []
    a.send(@method, 1...0).should == []

    expect( -> a.slice("a" .. "b") ).toThrow(TypeError)
    expect( -> a.slice("a" ... "b") ).toThrow(TypeError)
    expect( -> a.slice(from .. "b") ).toThrow(TypeError)
    expect( -> a.slice(from ... "b") ).toThrow(TypeError)

  it "returns the same elements as [m..n] and [m...n] with Range subclasses", ->
    a = [1, 2, 3, 4]
    range_incl = ArraySpecs.MyRange.new(1, 2)
    range_excl = ArraySpecs.MyRange.new(-3, -1, true)

    a[range_incl].should == [2, 3]
    a[range_excl].should == [2, 3]

  it "returns nil for a requested index not in the array with [index]", ->
    [ "a", "b", "c", "d", "e" ].send(@method, 5).should == nil

  it "returns [] if the index is valid but length is zero with [index, length]", ->
    [ "a", "b", "c", "d", "e" ].send(@method, 0, 0).should == []
    [ "a", "b", "c", "d", "e" ].send(@method, 2, 0).should == []

  it "returns nil if length is zero but index is invalid with [index, length]", ->
    [ "a", "b", "c", "d", "e" ].send(@method, 100, 0).should == nil
    [ "a", "b", "c", "d", "e" ].send(@method, -50, 0).should == nil

  # This is by design. It is in the official documentation.
  it "returns [] if index == array.size with [index, length]", ->
    %w|a b c d e|.send(@method, 5, 2).should == []

  it "returns nil if index > array.size with [index, length]", ->
    %w|a b c d e|.send(@method, 6, 2).should == nil

  it "returns nil if length is negative with [index, length]", ->
    %w|a b c d e|.send(@method, 3, -1).should == nil
    %w|a b c d e|.send(@method, 2, -2).should == nil
    %w|a b c d e|.send(@method, 1, -100).should == nil

  it "returns nil if no requested index is in the array with [m..n]", ->
    [ "a", "b", "c", "d", "e" ].send(@method, 6..10).should == nil

  it "returns nil if range start is not in the array with [m..n]", ->
    [ "a", "b", "c", "d", "e" ].send(@method, -10..2).should == nil
    [ "a", "b", "c", "d", "e" ].send(@method, 10..12).should == nil

  it "returns an empty array when m == n with [m...n]", ->
    [1, 2, 3, 4, 5].send(@method, 1...1).should == []

  it "returns an empty array with [0...0]", ->
    [1, 2, 3, 4, 5].send(@method, 0...0).should == []

  it "returns a subarray where m, n negatives and m < n with [m..n]", ->
    [ "a", "b", "c", "d", "e" ].send(@method, -3..-2).should == ["c", "d"]

  it "returns an array containing the first element with [0..0]", ->
    [1, 2, 3, 4, 5].send(@method, 0..0).should == [1]

  it "returns the entire array with [0..-1]", ->
    [1, 2, 3, 4, 5].send(@method, 0..-1).should == [1, 2, 3, 4, 5]

  it "returns all but the last element with [0...-1]", ->
    [1, 2, 3, 4, 5].send(@method, 0...-1).should == [1, 2, 3, 4]

  it "returns [3] for [2..-1] out of [1, 2, 3]", ->
    [1,2,3].send(@method, 2..-1).should == [3]

  it "returns an empty array when m > n and m, n are positive with [m..n]", ->
    [1, 2, 3, 4, 5].send(@method, 3..2).should == []

  it "returns an empty array when m > n and m, n are negative with [m..n]", ->
    [1, 2, 3, 4, 5].send(@method, -2..-3).should == []

  it "does not expand array when the indices are outside of the array bounds", ->
    a = [1, 2]
    a.send(@method, 4).should == nil
    a.should == [1, 2]
    a.send(@method, 4, 0).should == nil
    a.should == [1, 2]
    a.send(@method, 6, 1).should == nil
    a.should == [1, 2]
    a.send(@method, 8...8).should == nil
    a.should == [1, 2]
    a.send(@method, 10..10).should == nil
    a.should == [1, 2]

  describe "with a subclass of Array", ->
    before :each do
      ScratchPad.clear

      @array = ArraySpecs.MyArray[1, 2, 3, 4, 5]
  
    it "returns a subclass instance with [n, m]", ->
      @array.send(@method, 0, 2).should be_an_instance_of(ArraySpecs.MyArray)
  
    it "returns a subclass instance with [-n, m]", ->
      @array.send(@method, -3, 2).should be_an_instance_of(ArraySpecs.MyArray)
  
    it "returns a subclass instance with [n..m]", ->
      @array.send(@method, 1..3).should be_an_instance_of(ArraySpecs.MyArray)
  
    it "returns a subclass instance with [n...m]", ->
      @array.send(@method, 1...3).should be_an_instance_of(ArraySpecs.MyArray)
  
    it "returns a subclass instance with [-n..-m]", ->
      @array.send(@method, -3..-1).should be_an_instance_of(ArraySpecs.MyArray)
  
    it "returns a subclass instance with [-n...-m]", ->
      @array.send(@method, -3...-1).should be_an_instance_of(ArraySpecs.MyArray)
  
    it "returns an empty array when m == n with [m...n]", ->
      @array.send(@method, 1...1).should == []
      ScratchPad.recorded.should be_nil
  
    it "returns an empty array with [0...0]", ->
      @array.send(@method, 0...0).should == []
      ScratchPad.recorded.should be_nil
  
    it "returns an empty array when m > n and m, n are positive with [m..n]", ->
      @array.send(@method, 3..2).should == []
      ScratchPad.recorded.should be_nil
  
    it "returns an empty array when m > n and m, n are negative with [m..n]", ->
      @array.send(@method, -2..-3).should == []
      ScratchPad.recorded.should be_nil
  
    it "returns [] if index == array.size with [index, length]", ->
      @array.send(@method, 5, 2).should == []
      ScratchPad.recorded.should be_nil
  
    it "returns [] if the index is valid but length is zero with [index, length]", ->
      @array.send(@method, 0, 0).should == []
      @array.send(@method, 2, 0).should == []
      ScratchPad.recorded.should be_nil
  
    it "does not call #initialize on the subclass instance", ->
      @array.send(@method, 0, 3).should == [1, 2, 3]
      ScratchPad.recorded.should be_nil
  
  not_compliant_on :rubinius do
    it "raises a RangeError when the start index is out of range of Fixnum", ->
      array = [1, 2, 3, 4, 5, 6]
      obj = mock('large value')
      obj.should_receive(:to_int).and_return(0x8000_0000_0000_0000_0000)
      expect( -> array.send(@method, obj) ).toThrow(RangeError)

      obj = 8e19
      expect( -> array.send(@method, obj) ).toThrow(RangeError)
  
    it "raises a RangeError when the length is out of range of Fixnum", ->
      array = [1, 2, 3, 4, 5, 6]
      obj = mock('large value')
      obj.should_receive(:to_int).and_return(0x8000_0000_0000_0000_0000)
      expect( -> array.send(@method, 1, obj) ).toThrow(RangeError)

      obj = 8e19
      expect( -> array.send(@method, 1, obj) ).toThrow(RangeError)
  
  deviates_on :rubinius do
    it "raises a TypeError when the start index is out of range of Fixnum", ->
      array = [1, 2, 3, 4, 5, 6]
      obj = mock('large value')
      obj.should_receive(:to_int).and_return(0x8000_0000_0000_0000_0000)
      expect( -> array.send(@method, obj) ).toThrow(TypeError)

      obj = 8e19
      expect( -> array.send(@method, obj) ).toThrow(TypeError)
  
    it "raises a TypeError when the length is out of range of Fixnum", ->
      array = [1, 2, 3, 4, 5, 6]
      obj = mock('large value')
      obj.should_receive(:to_int).and_return(0x8000_0000_0000_0000_0000)
      expect( -> array.send(@method, 1, obj) ).toThrow(TypeError)

      obj = 8e19
      expect( -> array.send(@method, 1, obj) ).toThrow(TypeError)
