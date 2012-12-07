describe "Enumerable#one?", ->
  describe "when passed a block", ->
    it "returns true if block returns true once", ->
      expect( R(['a', 'b', 'c']).one (s) -> s is 'a' ).toEqual true

    it "returns false if the block returns true more than once", ->
      expect( R(['a', 'b', 'c']).one (s) -> s is 'a' || s is 'b' ).toEqual false

    it "returns false if the block only returns false", ->
      expect( R(['a', 'b', 'c']).one (s) -> s == 'd' ).toEqual false

    # ruby_version_is ""..."1.9", ->
    #   it "gathers whole arrays as elements when each yields multiple", ->
    #     multi = EnumerableSpecs.YieldsMulti.new
    #     multi.one? {|e| e == [1, 2] }.should be_true

    describe 'ruby_version_is "1.9"', ->
      xit "gathers initial args as elements when each yields multiple", ->
        multi = new EnumerableSpecs.YieldsMulti()
        expect( multi.one (e) -> e == 1 ).toEqual true

      it "yields multiple arguments when each yields multiple", ->
        multi = new EnumerableSpecs.YieldsMulti()
        yielded = []
        multi.one (e, i) -> yielded.push [e, i]
        expect( yielded ).toEqual [[1, 2], [3, 4]]

  describe "when not passed a block", ->
    it "returns true if only one element evaluates to true", ->
      expect( R([false, null, true]).one() ).toEqual true

    it "returns false if two elements evaluate to true", ->
      expect( R([false, 'value', null, true]).one() ).toEqual false

    it "returns false if all elements evaluate to false", ->
      expect( R([false, null, false]).one() ).toEqual false

    xit "gathers whole arrays as elements when each yields multiple", ->
      # multi = EnumerableSpecs.YieldsMultiWithSingleTrue.new
      # multi.one?.should be_false
