describe "Array#combination", ->
  # ruby_version_is "1.8.7", ->
  beforeEach ->
    @array = R [1, 2, 3, 4]

  it "returns an enumerator when no block is provided", ->
    expect( @array.combination(2) ).toBeInstanceOf R.Enumerator

  it "returns self when a block is given", ->
    expect( @array.combination(2, ->) is @array).toEqual true

  it "yields nothing for out of bounds length and return self", ->
    expect( @array.combination(5).to_a() ).toEqual R([])
    expect( @array.combination(-1).to_a() ).toEqual R([])

    expect( @array.combination(5, ->) is @array ).toEqual true

  it "yields the expected combinations", ->
    expect( @array.combination(3).to_a().valueOf() ).toEqual [[1,2,3],[1,2,4],[1,3,4],[2,3,4]]

  it "yields nothing if the argument is out of bounds", ->
    expect( @array.combination(-1).to_a() ).toEqual R([])
    expect( @array.combination(5).to_a() ).toEqual R([])

  it "yields a copy of self if the argument is the size of the receiver", ->
    r = @array.combination(4).to_a()
    expect( r ).toEqual R([@array.to_native()])
    expect( r.at(0) is @array).toEqual false

  it "yields [] when length is 0", ->
    expect( @array.combination(0).to_a().valueOf() ).toEqual [[]] # one combination of length 0
    expect( R([]).combination(0).to_a().valueOf() ).toEqual [[]] # one combination of length 0

  it "yields a partition consisting of only singletons", ->
    expect( @array.combination(1).to_a().valueOf() ).toEqual [[1],[2],[3],[4]]

  it "generates from a defensive copy, ignoring mutations", ->
    # TODO: test
    # accum = []
    # @array.combination(2) do |x|
    #   accum << x
    #   @array[0] = 1
    #     accum.should == [[1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4]]
