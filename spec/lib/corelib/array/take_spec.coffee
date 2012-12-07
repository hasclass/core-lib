describe 'ruby_version_is "1.8.7"', ->
  describe "Array#take", ->
    it "returns the first specified number of elements", ->
      expect( R([1, 2, 3]).take(2) ).toEqual R([1, 2])

    it "returns all elements when the argument is greater than the Array size", ->
      expect( R([1, 2]).take(99) ).toEqual R([1, 2])

    it "returns all elements when the argument is less than the Array size", ->
      expect( R([1, 2]).take(4) ).toEqual R([1, 2])

    it "returns an empty Array when passed zero", ->
      expect( R([1]).take(0) ).toEqual R([])

    it "returns an empty Array when called on an empty Array", ->
      expect( R([]).take(3) ).toEqual R([])

    it "raises an ArgumentError when the argument is negative", ->
      expect( -> R([1]).take(-3) ).toThrow('ArgumentError')
