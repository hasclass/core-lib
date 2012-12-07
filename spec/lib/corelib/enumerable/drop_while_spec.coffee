describe 'ruby_version_is "1.8.7"', ->
  describe "Enumerable#drop_while", ->
    beforeEach ->
      @enum = EnumerableSpecs.NumerousLiteral.new(3, 2, 1, 'go')

    it "returns an Enumerator if no block given", ->
      expect( @enum.drop_while() ).toBeInstanceOf R.Enumerator

    it "returns no/all elements for {true/false} block", ->
      expect( @enum.drop_while( -> true)  ).toEqual R([])
      expect( @enum.drop_while( -> false) ).toEqual @enum.to_a()

    it "accepts returns other than true/false", ->
      expect( @enum.drop_while( -> 1)   ).toEqual R([])
      expect( @enum.drop_while( -> null) ).toEqual @enum.to_a()

    it "passes elements to the block until the first false", ->
      a = R []
      expect( @enum.drop_while( (obj) -> a.append(obj).size().lt(3)) ).toEqual R([1, 'go'])
      expect( a ).toEqual R([3, 2, 1])

    xit "will only go through what's needed", ->
      # TODO check for this
      # enum = EnumerableSpecs.EachCounter.new(1,2,3,4)
      # enum.drop_while { |x|
      #   break 42 if x == 3
      #   true
      # }.should == 42
      # enum.times_yielded.should == 3

    it "doesn't return self when it could", ->
      a = R [1,2,3]
      expect(a.drop_while( -> false) is a).toEqual false

    it "gathers whole arrays as elements when each yields multiple", ->
      multi = new EnumerableSpecs.YieldsMulti()
      expect( multi.drop_while (e...) -> !R(e).size().equals(4) ).toEqual R([[6, 7, 8, 9]])
