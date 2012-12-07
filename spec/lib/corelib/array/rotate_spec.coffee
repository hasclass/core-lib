describe "Array#rotate", ->
  describe "when passed no argument", ->
    it "returns a copy of the array with the first element moved at the end", ->
      expect( R([1, 2, 3, 4, 5]).rotate() ).toEqual R([2, 3, 4, 5, 1])

  describe "with an argument n", ->
    it "returns a copy of the array with the first (n % size) elements moved at the end", ->
      a = R [1, 2, 3, 4, 5]
      expect( a.rotate(  2) ).toEqual R([3, 4, 5, 1, 2])
      expect( a.rotate( -1) ).toEqual R([5, 1, 2, 3, 4])
      expect( a.rotate(-21) ).toEqual R([5, 1, 2, 3, 4])
      expect( a.rotate( 13) ).toEqual R([4, 5, 1, 2, 3])
      expect( a.rotate(  0) ).toEqual R(a)

    it "coerces the argument using to_int", ->
      expect( R([1, 2, 3]).rotate(2.6) ).toEqual R([3, 1, 2])

      obj = {to_int: -> R(2)}
      expect( R([1, 2, 3]).rotate(obj) ).toEqual R([3, 1, 2])

    it "raises a TypeError if not passed an integer-like argument", ->
      expect( -> R([1, 2]).rotate(null) ).toThrow('TypeError')
      expect( -> R([1, 2]).rotate("4") ).toThrow('TypeError')

  it "returns a copy of the array when its length is one or zero", ->
    expect( R([1]).rotate()    ).toEqual R([1])
    expect( R([1]).rotate(2)   ).toEqual R([1])
    expect( R([1]).rotate(-42) ).toEqual R([1])
    expect( R([ ]).rotate()    ).toEqual R([])
    expect( R([ ]).rotate(2)   ).toEqual R([])
    expect( R([ ]).rotate(-42) ).toEqual R([])

#   it "does not mutate the receiver", ->
#     expect( ->
#       [].freeze.rotate
#       [2].freeze.rotate(2)
#       [1,2,3].freeze.rotate(-3)
#     }.should_not raise_error

  it "does not return self", ->
    a = R [1, 2, 3]
    expect( a.rotate() is a).toEqual false
    a = R []
    expect( a.rotate(0) is a).toEqual false

  #   ruby_version_is "" ... "1.9.3", ->
  xit "returns subclass instance for Array subclasses", ->
      # ArraySpecs.MyArray[1, 2, 3].rotate.should be_kind_of(ArraySpecs.MyArray)

  # ruby_version_is "1.9.3", ->
  xit "does not return subclass instance for Array subclasses", ->
      # ArraySpecs.MyArray[1, 2, 3].rotate.should be_an_instance_of(Array)

describe "Array#rotate!", ->
  describe "when passed no argument", ->
    it "moves the first element to the end and returns self", ->
      a = R [1, 2, 3, 4, 5]
      expect( a.rotate_bang() is a ).toEqual true
      expect( a ).toEqual R([2, 3, 4, 5, 1])

  describe "with an argument n", ->
    it "moves the first (n % size) elements at the end and returns self", ->
      a = R [1, 2, 3, 4, 5]
      expect( a.rotate_bang(2) is a ).toEqual true
      expect( a ).toEqual R([3, 4, 5, 1, 2])
      expect( a.rotate_bang(-12) is a ).toEqual true
      expect( a ).toEqual R([1, 2, 3, 4, 5])
      expect( a.rotate_bang(13) is a ).toEqual true
      expect( a ).toEqual R([4, 5, 1, 2, 3])

    it "coerces the argument using to_int", ->
      expect( R([1, 2, 3]).rotate_bang(2.6) ).toEqual R([3, 1, 2])

      obj = {to_int: -> R(2) }
      expect( R([1, 2, 3]).rotate_bang(obj) ).toEqual R([3, 1, 2])

    it "raises a TypeError if not passed an integer-like argument", ->
      expect( -> R([1, 2]).rotate_bang(null) ).toThrow('TypeError')
      expect( -> R([1, 2]).rotate_bang("4") ).toThrow('TypeError')

  it "does nothing and returns self when the length is zero or one", ->
    a = R [1]
    expect( a.rotate_bang() is a ).toEqual true
    expect( a ).toEqual R([1])
    expect( a.rotate_bang(2) is a ).toEqual true
    expect( a ).toEqual R([1])
    expect( a.rotate_bang(-21) is a ).toEqual true
    expect( a ).toEqual R([1])

    a = R []
    expect( a.rotate_bang() is a ).toEqual true
    expect( a ).toEqual R([])
    expect( a.rotate_bang(2) is a ).toEqual true
    expect( a ).toEqual R([])
    expect( a.rotate_bang(-21) is a ).toEqual true
    expect( a ).toEqual R([])

  # it "raises a RuntimeError on a frozen array", ->
  #   expect( -> [1, 2, 3].freeze.rotate_bang(0) ).toThrow(RuntimeError)
  #   expect( -> [1].freeze.rotate_bang(42) ).toThrow(RuntimeError)
  #   expect( -> [].freeze.rotate_bang ).toThrow(RuntimeError)
