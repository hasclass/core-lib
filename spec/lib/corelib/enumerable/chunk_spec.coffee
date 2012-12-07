xdescribe "Enumerable#chunk", ->
  it "raises an ArgumentError if called without a block", ->
    expect( -> EnumerableSpecs.Numerous.new().chunk() ).toThrow "ArgumentError"

  it "returns an Enumerator if given a block", ->
    expect( EnumerableSpecs.Numerous.new().chunk(() ->) ).toBeInstanceOf(RubyJS.Enumerator)

  xit "yields each element of the Enumerable to the block", ->
    yields = []
    EnumerableSpecs.Numerous.new().chunk((e) -> yields.push(e)).to_a()
    EnumerableSpecs.Numerous.new().to_a().should == yields

  it "returns an Enumerator of 2-element Arrays", ->
    EnumerableSpecs.Numerous.new().chunk(-> true).each (a) ->
      expect( a ).toBeInstanceOf RubyJS.Array
      expect( a.size() ).toEqual 2

  it "sets the first element of each sub-Array to the return value of the block", ->
    EnumerableSpecs.Numerous.new().chunk( (e) -> -e ).each (a) ->
      expect( a.first() ).toEqual -a.last().first()

  it "sets the last element of each sub-Array to the consecutive values for which the block returned the first element", ->
    ret = EnumerableSpecs.Numerous.new(5,5,2,3,4,5,7,1,9).chunk((e) -> e >= 5 ).to_a()
    ret = ret.unbox(true)
    expect( ret[0][1] ).toEqual [5, 5]
    expect( ret[1][1] ).toEqual [2, 3, 4]
    expect( ret[2][1] ).toEqual [5, 7]
    expect( ret[3][1] ).toEqual [1]
    expect( ret[4][1] ).toEqual [9]
