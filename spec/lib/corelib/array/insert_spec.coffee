describe "Array#insert", ->
  it "returns self", ->
    ary = R []
    expect( ary.insert(0)      is ary).toEqual true
    expect( ary.insert(0, "a") is ary).toEqual true

  it "inserts objects before the element at index for non-negative index", ->
    ary = R []
    expect( ary.insert(0, 3)    ).toEqual R([3])
    expect( ary.insert(0, 1, 2) ).toEqual R([1, 2, 3])
    expect( ary.insert(0)       ).toEqual R([1, 2, 3])

    # Let's just assume insert() always modifies the array from now on.
    expect( ary.insert(1, 'a')   ).toEqual R([1, 'a', 2, 3])
    expect( ary.insert(0, 'b')   ).toEqual R(['b', 1, 'a', 2, 3])
    expect( ary.insert(5, 'c')   ).toEqual R(['b', 1, 'a', 2, 3, 'c'])
    expect( ary.insert(7, 'd')   ).toEqual R(['b', 1, 'a', 2, 3, 'c', null, 'd'])
    expect( ary.insert(10, 5, 4) ).toEqual R(['b', 1, 'a', 2, 3, 'c', null, 'd', null, null, 5, 4])

  it "appends objects to the end of the array for index == -1", ->
    expect( R([1, 3, 3]).insert(-1, 2, 'x', 0.5) ).toEqual R([1, 3, 3, 2, 'x', 0.5])

  it "inserts objects after the element at index with negative index", ->
    ary = R []
    expect( ary.insert(-1, 3)  ).toEqual R([3])
    expect( ary.insert(-2, 2)  ).toEqual R([2, 3])
    expect( ary.insert(-3, 1)  ).toEqual R([1, 2, 3])
    expect( ary.insert(-2, -3) ).toEqual R([1, 2, -3, 3])
    expect( ary.insert(-1, []) ).toEqual R([1, 2, -3, 3, []])
    expect( ary.insert(-2, 'x', 'y') ).toEqual R([1, 2, -3, 3, 'x', 'y', []])
    ary = [1, 2, 3]

  it "pads with nulls if the index to be inserted to is past the end", ->
    expect( R([]).insert(5, 5) ).toEqual R([null, null, null, null, null, 5])

  it "can insert before the first element with a negative index", ->
    expect( R([1, 2, 3]).insert(-4, -3) ).toEqual R([-3, 1, 2, 3])

  it "raises an IndexError if the negative index is out of bounds", ->
    expect( -> R([ ]).insert(-2, 1) ).toThrow('IndexError')
    expect( -> R([1]).insert(-3, 2) ).toThrow('IndexError')

  it "does nothing of no object is passed", ->
    expect( R([]).insert(0 ) ).toEqual R([])
    expect( R([]).insert(-1) ).toEqual R([])
    expect( R([]).insert(10) ).toEqual R([])
    expect( R([]).insert(-2) ).toEqual R([])

  it "tries to convert the passed position argument to an Integer using #to_int", ->
    obj =
      to_int: -> R(2)
    expect( R([]).insert(obj, 'x') ).toEqual R([null, null, 'x'])

  it "raises an ArgumentError if no argument passed", ->
    expect( -> R([]).insert() ).toThrow('ArgumentError')

  # ruby_version_is ""..."1.9", ->
  #   it "raises a TypeError on frozen arrays when the array is modified", ->
  #     expect( -> ArraySpecs.frozen_array.insert(0, 'x') ).toThrow('TypeError')

  #   it "does not raise on frozen arrays when the array would not be modified", ->
  #     ArraySpecs.frozen_array.insert(0).should == [1, 2, 3]

  # ruby_version_is "1.9", ->
  #   it "raises a RuntimeError on frozen arrays when the array is modified", ->
  #     expect( -> ArraySpecs.frozen_array.insert(0, 'x') ).toThrow('RuntimeError')

  #   # see [ruby-core:23666]
  #   it "raises a RuntimeError on frozen arrays when the array would not be modified", ->
  #     expect( -> ArraySpecs.frozen_array.insert(0)      ).toThrow('RuntimeError')
