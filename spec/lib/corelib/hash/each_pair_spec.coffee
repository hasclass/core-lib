
describe "Hash#each_pair", ->
  it "yields a [key, value] Array for each pair to a block expecting |*args|", ->
    all_args = R([])

    h = R.hashify({'1': 2, '3': 4})
    h2 = h.each_pair (args...) -> all_args.append(args)
    expect( h2 == h).toEqual true

    expect( all_args.sort() ).toEqual R([['1', 2], ['3', 4]])



describe "Hash#each_value no block", ->
  beforeEach ->
    @hsh   = R.hashify({1: 2, 3: 4, 5: 6})
    @empty = R.hashify({})

  describe "1.8.7", ->
    it "returns an Enumerator if called on a non-empty hash without a block", ->
      expect( @hsh.each_pair() ).toBeInstanceOf(R.Enumerator)

    it "returns an Enumerator if called on an empty hash without a block", ->
      expect( @empty.each_pair() ).toBeInstanceOf(R.Enumerator)

    xit "returns an Enumerator if called on a frozen instance", ->
      @hsh.freeze()
      expect( @hsh.each_pair() ).toBeInstanceOf(R.Enumerator)
