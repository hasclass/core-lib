describe 'ruby_version_is "1.8.7"', ->
  describe "Enumerable#none?", ->
    it "returns true if none of the elements in self are true", ->
      e = EnumerableSpecs.NumerousLiteral.new(false, null, false)
      expect( e.none() ).toEqual true

    it "returns false if at least one of the elements in self are true", ->
      e = EnumerableSpecs.NumerousLiteral.new(false, null, true, false)
      expect( e.none() ).toEqual false

    xit "gathers whole arrays as elements when each yields multiple", ->
      # multi = EnumerableSpecs.YieldsMultiWithFalse.new()
      # expect( multi.none() ).toEqual alse

  describe "Enumerable#none? with a block", ->
    beforeEach ->
      @e = EnumerableSpecs.NumerousLiteral.new(1,1,2,3,4)

    it "passes each element to the block in turn until it returns true", ->
      acc = R []
      @e.none((e) -> acc.push(e); false )
      expect( acc.valueOf() ).toEqual [1,1,2,3,4]

    it "stops passing elements to the block when it returns true", ->
      acc = R []
      @e.none((e) -> acc.push(e); e is 3)
      expect( acc.valueOf() ).toEqual [1,1,2,3]

    it "returns true if the block never returns true", ->
      expect( @e.none( -> false ) ).toEqual true

    it "returns false if the block ever returns true", ->
      expect( @e.none((e) -> e is 3 ) ).toEqual false

  #   ruby_version_is ""..."1.9", ->
  #     it "gathers whole arrays as elements when each yields multiple", ->
  #       multi = EnumerableSpecs.YieldsMulti.new
  #       multi.none? {|e| e == 1 }.should be_true

    describe 'ruby_version_is "1.9"', ->
      it "gathers initial args as elements when each yields multiple", ->
        multi = new EnumerableSpecs.YieldsMulti()
        expect( multi.none (e) -> e == [1, 2] ).toEqual true

      it "yields multiple arguments when each yields multiple", ->
        multi = new EnumerableSpecs.YieldsMulti()
        yielded = []
        multi.none (e, i) -> yielded.push [e, i]
        expect( yielded ).toEqual [[1, 2]]
