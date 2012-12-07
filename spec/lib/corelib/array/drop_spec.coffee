describe 'ruby_version_is "1.8.7"', ->
  describe "Array#drop", ->
    it "removes the specified number of elements from the start of the array", ->
      expect( R([1, 2, 3, 4, 5]).drop(2) ).toEqual R([3, 4, 5])

    it "raises an ArgumentError if the number of elements specified is negative", ->
     expect( -> R([1, 2]).drop(-3) ).toThrow('ArgumentError')

    it "returns an empty Array if all elements are dropped", ->
      expect( R([1, 2]).drop(2) ).toEqual R([])

    it "returns an empty Array when called on an empty Array", ->
      expect( R([]).drop(0) ).toEqual R([])

    it "does not remove any elements when passed zero", ->
      expect( R([1, 2]).drop(0) ).toEqual R([1, 2])

    it "returns an empty Array if more elements than exist are dropped", ->
      expect( R([1, 2]).drop(3) ).toEqual R([])
