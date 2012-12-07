describe "Array#first", ->
  it "returns the first element", ->
    expect( R(['a', 'b', 'c']).first() ).toEqual 'a'
    expect( R([null]).first() ).toEqual null

  it "returns nil if self is empty", ->
    expect( R([]).first() ).toEqual null

  it "returns the first count elements if given a count", ->
    expect( R([true, false, true, null, false]).first(2).unbox()).toEqual [true, false]

  it "returns an empty array when passed count on an empty array", ->
    expect( R([]).first(0).unbox() ).toEqual []
    expect( R([]).first(1).unbox() ).toEqual []
    expect( R([]).first(2).unbox() ).toEqual []

  it "returns an empty array when passed count == 0", ->
    expect( R([1, 2, 3, 4, 5]).first(0).unbox()).toEqual []

  it "returns an array containing the first element when passed count == 1", ->
    expect( R([1, 2, 3, 4, 5]).first(1).unbox() ).toEqual [1]

  it "raises an ArgumentError when count is negative", ->
    expect( -> R([1, 2]).first(-1) ).toThrow("ArgumentError")

  it "returns the entire array when count > length", ->
    expect( R([1, 2, 3, 4, 5, 9]).first(10).unbox()).toEqual [1, 2, 3, 4, 5, 9]

  # it "returns an array which is independent to the original when passed count", ->
  #   ary = [1, 2, 3, 4, 5]
  #   ary.first(0).replace([1,2])
  #   expect( ary).toEqual [1, 2, 3, 4, 5]
  #   ary.first(1).replace([1,2])
  #   expect( ary).toEqual [1, 2, 3, 4, 5]
  #   ary.first(6).replace([1,2])
  #   expect( ary).toEqual [1, 2, 3, 4, 5]

  # it "properly handles recursive arrays", ->
  #   empty = ArraySpecs.empty_recursive_array
  #   empty.first.should equal(empty)

  #   ary = ArraySpecs.head_recursive_array
  #   ary.first.should equal(ary)

  # it "tries to convert the passed argument to an Integer using #to_int", ->
  #   obj = mock('to_int')
  #   obj.should_receive(:to_int).and_return(2)
  #   expect( [1, 2, 3, 4, 5].first(obj)).toEqual [1, 2]

  # it "raises a TypeError if the passed argument is not numeric", ->
  #   lambda { [1,2].first(nil) }.should raise_error(TypeError)
  #   lambda { [1,2].first("a") }.should raise_error(TypeError)

  #   obj = mock("nonnumeric")
  #   lambda { [1,2].first(obj) }.should raise_error(TypeError)

  # it "does not return subclass instance when passed count on Array subclasses", ->
  #   ArraySpecs::MyArray[].first(0).should be_kind_of(Array)
  #   ArraySpecs::MyArray[].first(2).should be_kind_of(Array)
  #   ArraySpecs::MyArray[1, 2, 3].first(0).should be_kind_of(Array)
  #   ArraySpecs::MyArray[1, 2, 3].first(1).should be_kind_of(Array)
  #   ArraySpecs::MyArray[1, 2, 3].first(2).should be_kind_of(Array)

  it "is not destructive", ->
    a = R [1, 2, 3]
    a.first()
    expect( a.unbox() ).toEqual [1, 2, 3]
    a.first(2)
    expect( a.unbox() ).toEqual [1, 2, 3]
