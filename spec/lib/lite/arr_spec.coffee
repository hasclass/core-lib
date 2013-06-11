describe "_arr", ->
  describe "rindex", ->
    it "splats block arguments", ->
      expect( _arr.rindex([1,[1,2],2], (a,b) -> b == 2 ) ).toEqual 1

  describe "keep_if", ->
    it "splats block arguments", ->
      expect( _arr.keep_if([1,[1,2],2], (a,b) -> b == 2 ) ).toEqual [[1,2]]

  describe "each", ->
    it "splats block arguments", ->
      arr = []
      _arr.each([1,[1,2],2], (a,b) -> arr.push(b) )
      expect( arr ).toEqual [undefined,2,undefined]

  describe "reverse_each", ->
    it "splats block arguments", ->
      arr = []
      _arr.reverse_each([1,[1,2],2], (a,b) -> arr.push(b) )
      expect( arr ).toEqual [undefined,2,undefined]

