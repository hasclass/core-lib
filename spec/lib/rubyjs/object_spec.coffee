describe "Object", ->
  describe "#__extract_block", ->
    beforeEach ->
      @obj  = new R.Object()
      @fn   = ->
      @args = (args...) -> return args

    it "returns the block/function if it finds one", ->
      expect( @obj.__extract_block(@args(@fn)) ).toEqual @fn
      expect( @obj.__extract_block(@args 1,2, @fn) ).toEqual @fn

    it "returns the last block/function", ->
      fn1 = ->
      expect( @obj.__extract_block(@args(fn1, @fn)) ).toEqual @fn

    it "returns null if it does not find a block", ->
      expect( @obj.__extract_block(@args null) ).toEqual null
      expect( @obj.__extract_block(@args 1,2) ).toEqual null

    it "removes function if it finds one", ->
      args = @args( @fn )
      expect( args.length ).toEqual 1
      @obj.__extract_block(args)
      expect( args.length ).toEqual 0

