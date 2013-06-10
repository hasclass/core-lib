describe 'ruby_version_is "1.8.7"', ->
  describe "Range#max", ->
    it "returns the maximum value in the range when called with no arguments", ->
      expect( R.Range.new(1,10          ).max() ).toEqual(10)
      expect( R.Range.new(1,10, true    ).max() ).toEqual(9)
      expect( R.Range.new('f','l'       ).max() ).toEqual('l')
      expect( R.Range.new('a','f', true ).max() ).toEqual('e')

    describe '"1.9"', ->
      it "returns the maximum value in the Float range when called with no arguments", ->
        expect( R.Range.new(303.20,908.1111).max() ).toEqual 908.1111

      xit "raises TypeError when called on an exclusive range and a non Integer value", ->
        expect( -> R.Range.new(303.20,908.1111,true).max() ).toThrow "TypeError"

    xdescribe 'ruby_version_is ""..."1.9"', ->
      it "raises TypeError when called on a Float range", ->
        expect( -> R.Range.new(303.20,908.1111,true).max() ).toThrow "TypeError"

    it "returns nil when the endpoint is less than the start point", ->
      expect( R.Range.new(100, 10).max()    ).toEqual null
      expect( R.Range.new('z', 'l').max()   ).toEqual null
      expect( R.Range.new(5, 5, true).max() ).toEqual null

    describe "1.9", ->
      it "returns nil when the endpoint is less than the start point in a Float range", ->
        expect( R.Range.new(3003.20, 908.1111).max() ).toEqual null

  describe "Range#max given a block", ->
    it "passes each pair of values in the range to the block", ->
      acc = R []
      R.Range.new(1, 10).max (a,b) -> acc.push [a,b]; a
      acc = acc.flatten()
      R.Range.new(1, 10).each (value) ->
        expect(  acc.include(value) ).toEqual true

    it "passes each pair of elements to the block in reversed order", ->
      acc = []
      R.Range.new(1, 5).max (a,b) -> acc.push [a,b]; a
      expect( acc ).toEqual  [[2,1],[3,2], [4,3], [5, 4]]

    xit "calls #> and #< on the return value of the block", ->
      # obj = mock('obj')
      # obj.should_receive(:>).exactly(2).times
      # obj.should_receive(:<).exactly(2).times
      # R.Range.new(1, 3).max {|a,b| obj }

    it "returns the element the block determines to be the maximum", ->
      expect( R.Range.new(1, 3).max (a,b) -> -3 ).toEqual 1

    it "returns nil when the endpoint is less than the start point", ->
      expect( R.Range.new(100, 10 ).max (x,y) -> x['<=>'](y) ).toEqual null
      expect( R.Range.new('z', 'l').max (x,y) -> x['<=>'](y) ).toEqual null
