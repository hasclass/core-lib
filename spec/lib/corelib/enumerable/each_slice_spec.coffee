describe "Enumerable#each_slice", ->
  beforeEach ->
    @en = EnumerableSpecs.NumerousLiteral.new(7,6,5,4,3,2,1)
    @sliced = [[7,6,5],[4,3,2],[1]]


  it "works with each_slice(1)", ->
    acc = []
    R([1,2]).each_slice(1, (g) -> acc.push g)
    R([1,2]).each_slice(1, (g) -> acc.push g)
    expect( acc ).toEqual [[1],[2], [1], [2]]


  it "passes element groups to the block", ->
    acc = []
    expect( @en.each_slice(3, (g) -> acc.push g) ).toEqual null
    expect( acc ).toEqual @sliced

  it "raises an Argument Error if there is not a single parameter > 0", ->
    en = @en
    expect( ->  en.each_slice(0)    ).toThrow('ArgumentError')
    expect( ->  en.each_slice(-2)   ).toThrow('ArgumentError')
    expect( ->  en.each_slice()     ).toThrow('ArgumentError')
    expect( ->  en.each_slice(2,2)  ).toThrow('ArgumentError')

  it "tries to convert n to an Integer using #to_int", ->
    acc = []
    expect( @en.each_slice(3.3, (g) -> acc.push(g) )).toEqual null
    expect( acc ).toEqual @sliced


    obj =
      to_int: -> R(3)
    spy = spyOn(obj, 'to_int').andReturn(R(3))
    en = @en
    expect( en.catch_break (breaker) ->
      en.each_slice(obj, (g) -> breaker.break g.length )
    ).toEqual 3

  it "works when n is >= full length", ->
    full = @en.to_a()
    acc = R []
    @en.each_slice(full.size(), (g) -> acc.append g)
    expect( acc.flatten().size() ).toEqual full.size()

    acc = R []
    @en.each_slice(full.size().plus(1), (g) -> acc.append g)
    expect( acc.flatten().size() ).toEqual full.size()

  xit "yields only as much as needed", ->
    # cnt = EnumerableSpecs.EachCounter.new(1, 2, :stop, "I said stop!", :got_it)
    # cnt.each_slice(2) {|g| break 42 if g[0] == :stop }.should == 42
    # cnt.times_yielded.should == 4

  describe 'ruby_version_is "1.9.3"', ->
    it "returns an enumerator if no block", ->
      e = R([1,2,3,4]).each_slice(3)
      expect( e ).toBeInstanceOf R.Enumerator
      expect( e.to_a().to_native() ).toEqual [[1,2,3], [4]]

    it "gathers whole arrays as elements when each yields multiple", ->
      multi = new EnumerableSpecs.YieldsMulti()
      expect( multi.each_slice(2).to_a().to_native() ).toEqual [[[1, 2], [3, 4, 5]], [[6, 7, 8, 9]]]





