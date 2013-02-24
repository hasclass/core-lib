describe "Hash#delete_if", ->
  it "yields two arguments: key and value", ->
    all_args = []
    R.hashify(1: 2, 3: 4).delete_if (args...) -> all_args.push(args)
    expect( all_args ).toEqual [['1', 2], ['3', 4]]

  it "removes every entry for which block is true and returns self", ->
    h = R.hashify(a: 1, b: 2, c: 3, d: 4)
    h2 = h.delete_if (k, v) -> v % 2 == 1
    expect( h is h2 ).toEqual true
    expect( h ).toEqual R.hashify(b: 2, d: 4)

  it "processes entries with the same order as each()", ->
    h = R.hashify({a: 1, b: 2, c: 3, d: 4})

    each_pairs = []
    delete_pairs = []

    h.each_pair (k,v) -> each_pairs.push([k, v])
    h.delete_if (k,v) -> delete_pairs.push([k, v])

    expect( each_pairs ).toEqual delete_pairs

#   ruby_version_is "" ... "1.9", ->
#     it "raises an TypeError if called on a frozen instance", ->
#       lambda { HashSpecs.frozen_hash.delete_if { false } }.should raise_error(TypeError)
#       lambda { HashSpecs.empty_frozen_hash.delete_if { true } }.should raise_error(TypeError)

  xit "raises an RuntimeError if called on a frozen instance", ->
    # lambda { HashSpecs.frozen_hash.delete_if { false } }.should raise_error(RuntimeError)
    # lambda { HashSpecs.empty_frozen_hash.delete_if { true } }.should raise_error(RuntimeError)


describe "Hash#delete_if no block", ->
  beforeEach ->
    @hsh   = R.hashify({1: 2, 3: 4, 5: 6})
    @empty = R.hashify({})

  describe "1.8.7", ->
    it "returns an Enumerator if called on a non-empty hash without a block", ->
      expect( @hsh.delete_if() ).toBeInstanceOf(R.Enumerator)

    it "returns an Enumerator if called on an empty hash without a block", ->
      expect( @empty.delete_if() ).toBeInstanceOf(R.Enumerator)

    xit "returns an Enumerator if called on a frozen instance", ->
      @hsh.freeze()
      expect( @hsh.delete_if() ).toBeInstanceOf(R.Enumerator)
