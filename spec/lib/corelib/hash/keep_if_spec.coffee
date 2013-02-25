describe "Hash#keep_if", ->
  it "yields two arguments: key and value", ->
    all_args = []
    R.hashify(1: 2, 3: 4).keep_if (args...) -> all_args.push(args)
    expect( all_args ).toEqual [['1', 2], ['3', 4]]

  it "keeps every entry for which block is true and returns self", ->
    h = R.hashify(a: 1, b: 2, c: 3, d: 4)
    h2 = h.keep_if (k,v) -> v % 2 == 0
    expect( h2 == h).toEqual true
    expect( h ).toEqual R.hashify(b: 2, d: 4)

  it "returns self even if unmodified", ->
    h = R.hashify(1: 2, 3: 4)
    h2 = h.keep_if(-> true)
    expect( h2 == h ).toEqual true

  xit "raises an RuntimeError if called on a frozen instance", ->
    # lambda { HashSpecs.frozen_hash.keep_if { true } }.should raise_error(RuntimeError)
    # lambda { HashSpecs.empty_frozen_hash.keep_if { false } }.should raise_error(RuntimeError)

  # it_behaves_like(:hash_iteration_no_block, :keep_if)
