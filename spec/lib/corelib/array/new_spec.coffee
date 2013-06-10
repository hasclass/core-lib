describe "Array.new", ->
  it "returns an instance of Array", ->
    expect( R.Array.new() ).toBeInstanceOf(R.Array)

  xit "returns an instance of a subclass", ->
    # ArraySpecs.MyArray.new(1, 2).should be_an_instance_of(ArraySpecs.MyArray)

  it "raise an ArgumentError if passed 3 or more arguments", ->
    expect( -> R.Array.new 1, 'x', true ).toThrow('ArgumentError')
    expect( -> R.Array.new(1, 'x', true, -> ) ).toThrow('ArgumentError')

describe "Array.new with no arguments", ->
  it "returns an empty array", ->
    expect( R.Array.new().empty() ).toEqual true

  it "does not use the given block", ->
    expect( -> R.Array.new -> throw '' ) #.should_not raise_error

describe "Array.new with (array)", ->
  it "returns an array initialized to the other array", ->
    b = [4, 5, 6]
    expect( R.Array.new(b)      ).toEqual R(b)
    expect( R.Array.new(R(b) ) ).toEqual R(b)

  it "does not use the given block", ->
    expect( -> R.Array.new([1, 2], -> throw '') ) #.should_not raise_error

  it "calls #to_ary to convert the value to an array", ->
    a =
      to_ary: -> R([1, 2])
      to_int: -> throw 'Do not go here'
    expect( R.Array.new(a) ).toEqual R([1, 2])

  it "does not call #to_ary on instances of Array or subclasses of Array", ->
    a = [1, 2]
    a.to_ary = -> throw 'do not go here'
    expect( R.Array.new(a) ).toEqual R(a)

  it "raises a TypeError if an Array type argument and a default object", ->
    expect( -> R.Array.new([1, 2], 1) ).toThrow('TypeError')

describe "Array.new with (size, object=nil)", ->
  it "returns an array of size filled with object", ->
    obj = [3]
    a = R.Array.new(2, obj)
    expect( a ).toEqual R([obj, obj])
    expect( a.at(0) is obj).toEqual true
    expect( a.at(1) is obj).toEqual true

  it "returns an array of size filled with nil when object is omitted", ->
    expect( R.Array.new(3) ).toEqual R([null, null, null])

  it "raises an ArgumentError if size is negative", ->
    expect( -> R.Array.new(-1, 'a') ).toThrow('ArgumentError')
    expect( -> R.Array.new(-1) ).toThrow('ArgumentError')

  # platform_is :wordsize => 32 do
  #   it "raises an ArgumentError if size is too large", ->
  #     max_size = ArraySpecs.max_32bit_size
  #     expect( -> Array.new(max_size + 1) ).toThrow(ArgumentError)

  # platform_is :wordsize => 64 do
  #   it "raises an ArgumentError if size is too large", ->
  #     max_size = ArraySpecs.max_64bit_size
  #     expect( -> Array.new(max_size + 1) ).toThrow(ArgumentError)

  it "calls #to_int to convert the size argument to an Integer when object is given", ->
    obj =
      to_int: -> R(1)
    expect( R.Array.new(obj, 'a') ).toEqual R(['a'])

  it "calls #to_int to convert the size argument to an Integer when object is not given", ->
    obj =
      to_int: -> R(1)
    expect( R.Array.new(obj) ).toEqual R([null])

  it "raises a TypeError if the size argument is not an Integer type", ->
    obj =
      to_ary: -> R([1, 2])
    expect( -> R.Array.new(obj, 'a') ).toThrow('TypeError')

  it "yields the index of the element and sets the element to the value of the block", ->
    expect( R.Array.new(3, (i) -> i + ""       ).valueOf() ).toEqual ['0', '1', '2']

  it "uses the block value instead of using the default value", ->
    expect( R.Array.new(3, "obj", (i) -> i + "").valueOf() ).toEqual ['0', '1', '2']

  it "returns the value passed to break", ->
    # a = R.Array.new(3) do |i|
    #   # break if i == 2
    #   i.to_s

    # a.should == nil
