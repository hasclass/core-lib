describe 'ruby_version_is "1.8.7"', ->
  describe "Range#min", ->
    it "returns the minimum value in the range when called with no arguments", ->
      expect( R.Range.new(1, 10).min() ).toEqual R(1)
      expect( R.Range.new('f', 'l').min() ).toEqual R('f')

    describe 'ruby_version_is "1.9"', ->
      it "returns the minimum value in the Float range when called with no arguments", ->
        expect( R.Range.new(303.20, 908.1111).min() ).toEqual R(303.20)

    # ruby_version_is ""..."1.9", ->
    #   it "raises TypeError when called on a Float range", ->
    #     lambda { (303.20..908.1111).min }.should raise_error(TypeError)

    it "returns nil when the start point is greater than the endpoint", ->
      expect( R.Range.new(100, 10).min()   ).toEqual null
      expect( R.Range.new('z', 'l').min()  ).toEqual null
      expect( R.Range.new(7,7, true).min() ).toEqual null

    describe 'ruby_version_is "1.9"', ->
      it "returns nil when the start point is greater than the endpoint in a Float range", ->
        expect( R.Range.new(3003.20, 908.1111).min() ).toEqual null

  describe "Range#min given a block", ->
    it "passes each pair of values in the range to the block", ->
      acc = R([])
      R.Range.new(1, 10).min (a,b) -> acc.push [a,b]; a
      acc = acc.flatten()
      R.Range.new(1, 10).each (value) ->
        expect( acc.include(value ) ).toEqual true

    it "passes each pair of elements to the block where the first argument is the current element, and the last is the first element", ->
      acc = []
      R.Range.new(1, 5).min (a,b) -> acc.push [a.to_native(), b.to_native()]; a
      expect( acc ).toEqual [[2, 1], [3, 1], [4, 1], [5, 1]]

    xit "calls #> and #< on the return value of the block", ->
      # obj = mock('obj')
      # obj.should_receive(:>).exactly(2).times
      # obj.should_receive(:<).exactly(2).times
      # R.Range.new(1, 3).min (a,b) -> obj }

    it "returns the element the block determines to be the minimum", ->
      expect( R.Range.new(1, 3).min (a,b) -> -3 ).toEqual  R(3)

    it "returns nil when the start point is greater than the endpoint", ->
      expect( R.Range.new(100, 10  ).min (x,y) -> x['<=>'](y) ).toEqual null
      expect( R.Range.new('z', 'l' ).min (x,y) -> x['<=>'](y) ).toEqual null
      expect( R.Range.new(7,7, true).min (x,y) -> x['<=>'](y) ).toEqual null
