describe 'ruby_version_is "1.8.7"', ->
  describe "Enumerable#count", ->
    beforeEach ->
      @elements = R [1, 2, 4, 2]
      @numerous = EnumerableSpecs.Numerous.new(1, 2, 4, 2)

    it "returns size when no argument or a block", ->
      expect( @numerous.count() ).toEqual R(4)

    it "counts nils if given nil as an argument", ->
      expect( EnumerableSpecs.Numerous.new(null, null, null, false).count(null) ).toEqual R(3)

    it "accepts an argument for comparison using ==", ->
      expect( @numerous.count(2) ).toEqual R(2)

    it "uses a block for comparison", ->
      expect( @numerous.count (x) -> x % 2 == 0  ).toEqual R(3)

    it "ignores the block when given an argument", ->
      expect( @numerous.count(4, (x) -> x % 2 == 0 ) ).toEqual R(1)

    # ruby_version_is ""..."1.9", ->
    #   it "gathers whole arrays as elements when each yields multiple", ->
    #     multi = EnumerableSpecs.YieldsMulti.new
    #     multi.count  (e) -> e == [1, 2]} ).toEqual R(1)

    xdescribe 'ruby_version_is "1.9"', ->
      it "gathers initial args as elements when each yields multiple", ->
        multi = EnumerableSpecs.YieldsMulti.new()
        expect( multi.count( (e) -> e == 1 ) ).toEqual R(1)
