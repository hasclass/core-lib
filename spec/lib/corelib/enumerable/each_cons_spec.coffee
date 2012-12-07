describe "Enumerable#each_cons", ->
  beforeEach ->
    @en = EnumerableSpecs.NumerousLiteral.new(4,3,2,1)
    @in_threes = [[4,3,2],[3,2,1]]
    @in_threes_str = R('[[4, 3, 2], [3, 2, 1]]')

  it "passes element groups to the block", ->
    acc = []
    expect( @en.each_cons 3, (g) -> acc.push(g) ).toEqual null
    expect( acc ).toEqual @in_threes

  it "raises an Argument Error if there is not a single parameter > 0", ->
    en = @en
    expect( -> en.each_cons(0, ->)    ).toThrow('ArgumentError')
    expect( -> en.each_cons(-2, ->)   ).toThrow('ArgumentError')
    expect( -> en.each_cons(->)       ).toThrow('ArgumentError')
    expect( -> en.each_cons(2,2, ->)  ).toThrow('ArgumentError')

  it "passes element groups to the block", ->
    acc = []
    expect( @en.each_cons 3.3, (g) -> acc.push(g) ).toEqual null
    expect( acc ).toEqual @in_threes

    obj =
      to_int: -> R(3)
    en = @en
    expect( R.catch_break (breaker) ->
      en.each_cons(obj, (g) -> breaker.break(g.length) ) ).toEqual 3

  xit "works when n is >= full length", ->
    # full = @en.to_a()
    # acc = []
    # @en.each_cons(full.length){|g| acc << g}
    # acc.should == [full]
    # acc = []
    # @en.each_cons(full.length+1){|g| acc << g}
    # acc.should == []

  xit "yields only as much as needed", ->
    # cnt = EnumerableSpecs.EachCounter.new(1, 2, :stop, "I said stop!", :got_it)
    # cnt.each_cons(2) {|g| break 42 if g[-1] == :stop }.should == 42
    # cnt.times_yielded.should == 3

  describe 'ruby_version_is "1.8.7"', ->
    it "returns an enumerator if no block", ->
      e = @en.each_cons(3)
      expect( e ).toBeInstanceOf R.Enumerator
      expect( e.to_a().to_native() ).toEqual @in_threes

    it "gathers whole arrays as elements when each yields multiple", ->
      multi = new EnumerableSpecs.YieldsMulti()
      expect( multi.each_cons(2).to_a() ).toEqual R([[[1,2], [3,4,5]], [[3,4,5], [6,7,8,9]]])
