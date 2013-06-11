describe "_arr", ->
  array = [1,[1,2],2]
  args = R.argify(1,[1,2],2)

  describe "rindex", ->
    it "splats block arguments", ->
      expect( _arr.rindex(array, (a,b) -> b == 2 ) ).toEqual 1
      expect( _arr.rindex(args, (a,b) -> b == 2 ) ).toEqual 1

  describe "keep_if", ->
    it "splats block arguments", ->
      expect( _arr.keep_if(array, (a,b) -> b == 2 ) ).toEqual [[1,2]]
      expect( _arr.keep_if(args, (a,b) -> b == 2 ) ).toEqual [[1,2]]

  describe "each", ->
    it "splats block arguments", ->
      arr = []
      _arr.each(array, (a,b) -> arr.push(b) )
      expect( arr ).toEqual [undefined,2,undefined]
      arr = []
      _arr.each(args, (a,b) -> arr.push(b) )
      expect( arr ).toEqual [undefined,2,undefined]

  describe "reverse_each", ->
    it "splats block arguments", ->
      arr = []
      _arr.reverse_each(array, (a,b) -> arr.push(b) )
      expect( arr ).toEqual [undefined,2,undefined]

      arr = []
      _arr.reverse_each(args, (a,b) -> arr.push(b) )
      expect( arr ).toEqual [undefined,2,undefined]

  describe "find_index", ->
    it "splats block arguments", ->
      expect( _arr.find_index(array, (a,b) -> b == 2) ).toEqual 1
      expect( _arr.find_index(args, (a,b) -> b == 2) ).toEqual 1

