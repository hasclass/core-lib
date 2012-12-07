describe 'ruby_version_is "1.8.7"', ->
  describe "Array#take_while", ->
    it "returns all elements until the block returns false", ->
      expect( R([1, 2, 3]).take_while( (element) -> element < 3 )).toEqual R([1, 2])

    it "returns all elements until the block returns nil", ->
      expect( R([1, 2, null, 4]).take_while( (element) -> element )).toEqual R([1, 2])

    it "returns all elements until the block returns false", ->
      expect( R([1, 2, false, 4]).take_while( (element) -> element )).toEqual R([1, 2])
