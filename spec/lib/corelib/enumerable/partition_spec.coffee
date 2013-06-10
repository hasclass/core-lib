describe "Enumerable#partition", ->
  it "returns two arrays, the first containing elements for which the block is true, the second containing the rest", ->
    expect(
      EnumerableSpecs.NumerousLiteral.new().partition((i) -> i % 2 is 0 ).valueOf()
    ).toEqual [[2, 6, 4], [5, 3, 1]]


  # ruby_version_is "" ... "1.8.7", ->
  #   it "throws LocalJumpError if called without a block", ->
  #     expect( ->  EnumerableSpecs.Numerous.new().partition ).toThrow(LocalJumpError)

  describe 'ruby_version_is "1.8.7"', ->
    it "returns an Enumerator if called without a block", ->
      expect( EnumerableSpecs.NumerousLiteral.new().partition() ).toBeInstanceOf R.Enumerator

  it "gathers whole arrays as elements when each yields multiple", ->
    multi = new EnumerableSpecs.YieldsMulti()
    expect(
      multi.partition( (e) -> R(e).size().equals(3) ).valueOf()
    ).toEqual [[[3,4,5]], [[1,2], [6,7,8,9]]]

