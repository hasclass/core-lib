describe "Array#last", ->
  it "returns the last element", ->
    expect( R([1, 1, 1, 1, 2]).last() ).toEqual 2

  it "returns nil if self is empty", ->
    expect( R([]).last() ).toEqual null

  it "returns the last count elements if given a count", ->
    expect( R([1, 2, 3, 4, 5, 9]).last(3) ).toEqual R([4, 5, 9])

  it "returns an empty array when passed a count on an empty array", ->
    expect( R([]).last(0) ).toEqual R([])
    expect( R([]).last(1) ).toEqual R([])

  it "returns an empty array when count == 0", ->
    expect( R([1, 2, 3, 4, 5]).last(0) ).toEqual R([])

  it "returns an array containing the last element when passed count == 1", ->
    expect( R([1, 2, 3, 4, 5]).last(1) ).toEqual R([5])

  it "raises an ArgumentError when count is negative", ->
    expect( -> R([1, 2]).last(-1) ).toThrow('ArgumentError')

  it "returns the entire array when count > length", ->
    expect( R([1, 2, 3, 4, 5, 9]).last(10) ).toEqual R([1, 2, 3, 4, 5, 9])

  it "returns an array which is independent to the original when passed count", ->
    ary = R([1, 2, 3, 4, 5])
    ary.last(0).replace([1,2])
    expect( ary ).toEqual R([1, 2, 3, 4, 5])
    ary.last(1).replace([1,2])
    expect( ary ).toEqual R([1, 2, 3, 4, 5])
    ary.last(6).replace([1,2])
    expect( ary ).toEqual R([1, 2, 3, 4, 5])

  it "properly handles recursive arrays", ->
    empty = R([])
    empty.push(empty)
    expect( empty.last() ).toEqual(empty)

  it "tries to convert the passed argument to an Integer usinig #to_int", ->
    obj =
      to_int: -> R(2)
    expect( R([1, 2, 3, 4, 5]).last(obj) ).toEqual R([4, 5])

  it "raises a TypeError if the passed argument is not numeric", ->
    expect( -> R([1,2]).last(null) ).toThrow('TypeError')
    expect( -> R([1,2]).last("a") ).toThrow('TypeError')
    expect( -> R([1,2]).last(new Object()) ).toThrow('TypeError')

  xit "does not return subclass instance on Array subclasses", ->
    # expect( ArraySpecs.MyArray[].last(0) ).toEqual(Array)
    # ArraySpecs.MyArray[].last(2).should be_kind_of(Array)
    # ArraySpecs.MyArray[1, 2, 3].last(0).should be_kind_of(Array)
    # ArraySpecs.MyArray[1, 2, 3].last(1).should be_kind_of(Array)
    # expect( ArraySpecs.MyArray[1, 2, 3].last(2) ).toEqual(Array)

  it "is not destructive", ->
    a = R([1, 2, 3])
    a.last()
    expect( a ).toEqual R([1, 2, 3])
    a.last(2)
    expect( a ).toEqual R([1, 2, 3])
    a.last(3)
    expect( a ).toEqual R([1, 2, 3])
