describe "Enumerable#take_while", ->
  describe "ruby_version_is '1.8.7'", ->
    beforeEach ->
      @en = EnumerableSpecs.Numerous.new(3, 2, 1, "go")

    it "returns an Enumerator if no block given", ->
      expect( @en.take_while() ).toBeInstanceOf R.Enumerator

    it "returns no/all elements for {true/false} block", ->
      expect( @en.take_while( -> true ) ).toEqual @en.to_a()
      expect( @en.take_while( -> false ) ).toEqual R([])

    it "accepts returns other than true/false", ->
      expect( @en.take_while( -> 1 ) ).toEqual @en.to_a()
      expect( @en.take_while( -> null ) ).toEqual R([])

    it "passes elements to the block until the first false", ->
      a = R []
      expect( @en.take_while((obj) -> a.push(obj).size().lt(3) ) ).toEqual R.$Array_r([3, 2])
      expect( a.unbox(true) ).toEqual [3, 2, 1]

    xit "will only go through what's needed", ->
      # en = EnumerableSpecs.EachCounter.new(4, 3, 2, 1, :stop)
      # en.take_while { |x|
      #   break 42 if x == 3
      #   true
      # }.should == 42
      # en.times_yielded.should == 2

    it "doesn't return self when it could", ->
      a = R [1,2,3]
      expect( a.take_while(-> true ) is a ).toEqual false
