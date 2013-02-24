describe "Hash#each_value", ->
  it "calls block once for each key, passing value", ->
    r = R([])
    h = R.hashify({a: -5, b: -3, c: -2, d: -1, e: -1})

    result = h.each_value (v) -> r.append(v)
    expect( result == h).toEqual true
    expect( r.sort() ).toEqual R([-5, -3, -2, -1, -1])

  it "processes values in the same order as values()", ->
    values = R([])
    h = R.hashify({a: -5, b: -3, c: -2, d: -1, e: -1})

    h.each_value (v) -> values.append(v)
    expect( values ).toEqual h.values()

  # it_behaves_like(:hash_iteration_no_block, :each_value)
describe "Hash#each_value no block", ->
  beforeEach ->
    @hsh   = R.hashify({1: 2, 3: 4, 5: 6})
    @empty = R.hashify({})

  describe "1.8.7", ->
    it "returns an Enumerator if called on a non-empty hash without a block", ->
      expect( @hsh.each_value() ).toBeInstanceOf(R.Enumerator)

    it "returns an Enumerator if called on an empty hash without a block", ->
      expect( @empty.each_value() ).toBeInstanceOf(R.Enumerator)

    xit "returns an Enumerator if called on a frozen instance", ->
      @hsh.freeze()
      expect( @hsh.each_value() ).toBeInstanceOf(R.Enumerator)
