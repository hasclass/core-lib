describe 'ruby_version_is "1.8.7"', ->
  describe "Array#count", ->
    it "returns the number of elements", ->
      expect( R(['a', 'b', 'c']).count() ).toEqual R(3)

    it "returns the number of elements that equal the argument", ->
      expect( R(['a', 'b', 'b', 'c']).count('b') ).toEqual R(2)

    it "returns the number of element for which the block evaluates to true", ->
      expect( R(['a', 'b', 'c']).count (s) -> !(s == 'b') ).toEqual R(2)
