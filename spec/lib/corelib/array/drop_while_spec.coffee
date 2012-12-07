describe 'ruby_version_is "1.8.7"', ->
  describe "Array#drop_while", ->
    it "removes elements from the start of the array while the block evaluates to true", ->
      expect( R([1, 2, 3, 4]).drop_while((n) -> n < 4  )  ).toEqual R([4])

    it "removes elements from the start of the array until the block returns nil", ->
      expect( R([1, 2, 3, null, 5]).drop_while((n) -> n )  ).toEqual R([null, 5])

    it "removes elements from the start of the array until the block returns false", ->
      expect( R([1, 2, 3, false, 5]).drop_while((n) -> n ) ).toEqual R([false, 5])
