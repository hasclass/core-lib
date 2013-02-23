argify = -> arguments

describe "Block", ->
  describe "block with 1 arg", ->
    beforeEach -> @block = R.Block.create((a) -> a)

    it "yields argument if invoked with one argument", ->
      expect( @block.invoke(argify('a')) ).toEqual 'a'

    it "yields first argument if invoked with n arguments", ->
      expect( @block.invoke(argify('a', 'b', 'c')) ).toEqual 'a'

  describe "block with n args", ->
    beforeEach -> @block = R.Block.create((a, b) -> [a,b])

    it "yields argument if invoked with one argument", ->
      expect( @block.invoke(argify('a')) ).toEqual ['a', undefined]

    it "yields first argument if invoked with n arguments", ->
      expect( @block.invoke(argify('a', 'b')) ).toEqual ['a', 'b']

    it "yields only necessary arguments and ignores the rest", ->
      expect( @block.invoke(argify('a', 'b', 'c')) ).toEqual ['a', 'b']

    it "splats array if one argument given", ->
      expect( @block.invoke(['a', 'b']) ).toEqual ['a', 'b']
      expect( @block.invoke(['a']) ).toEqual ['a', undefined]
      expect( @block.invoke(['a', 'b', 'c']) ).toEqual ['a', 'b']

    it "yields the first argument if one argument given", ->
      expect( @block.invoke(argify(  1  )) ).toEqual [1, undefined]
      expect( @block.invoke(argify( {}  )) ).toEqual [{}, undefined]
      expect( @block.invoke(argify( 'c' )) ).toEqual ['c', undefined]

    it "#args returns array for multiple arguments", ->
      expect( @block.args(argify( 1,2 )) ).toEqual [1, 2]

    it "#args returns single element for single arguments", ->
      expect( @block.args(argify( 1 )) ).toEqual 1

    it "#args returns undefined element for empty arguments", ->
      expect( @block.args(argify( )) ).toEqual undefined

  describe "non-block", ->
    beforeEach -> @block = R.Block.create(argify(1,2))

    it "yields argument if invoked with one argument", ->
      expect( @block.invoke(argify('a')) ).toEqual 'a'

    it "yields argument if invoked with one argument", ->
      expect( @block.invoke(argify(['a'])) ).toEqual ['a']

    it "yields argument if invoked with one argument", ->
      expect( @block.invoke(argify('a', 'b')) ).toEqual ['a', 'b']
