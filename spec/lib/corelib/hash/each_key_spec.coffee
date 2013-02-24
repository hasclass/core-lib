describe "Hash#each_key", ->
  it "calls block once for each key, passing key", ->
    r = R.hashify({})
    h = R.hashify({1: -1, 2: -2, 3: -3, 4: -4})
    h2 = h.each_key (k) -> r.set(k, k)
    expect( h2 == h ).toEqual true
    expect( r ).toEqual R.hashify(1: '1', 2: '2', 3: "3", 4: "4")

  it "processes keys in the same order as keys()", ->
    keys = R([])
    h = R.hashify(1: -1, 2: -2, 3: -3, 4: -4)
    h.each_key (k) -> keys.append(k)
    expect( keys ).toEqual h.keys()


describe "Hash#each_value no block", ->
  beforeEach ->
    @hsh   = R.hashify({1: 2, 3: 4, 5: 6})
    @empty = R.hashify({})

  describe "1.8.7", ->
    it "returns an Enumerator if called on a non-empty hash without a block", ->
      expect( @hsh.each_key() ).toBeInstanceOf(R.Enumerator)

    it "returns an Enumerator if called on an empty hash without a block", ->
      expect( @empty.each_key() ).toBeInstanceOf(R.Enumerator)

    xit "returns an Enumerator if called on a frozen instance", ->
      @hsh.freeze()
      expect( @hsh.each_key() ).toBeInstanceOf(R.Enumerator)
