describe "Hash#clear", ->
  it "removes all key, value pairs", ->
    h = R.hashify(1: 2, 3: 4)
    expect( h.clear() == h).toEqual true
    expect( h ).toEqual R.hashify({})

  it "does not remove default values", ->
    h = R.hashify({}, 5)
    h.clear()
    expect( h.default()).toEqual 5

    h = R.hashify({a: 100, b: 200}, "Go fish")
    h.clear()
    expect( h.get("z") ).toEqual "Go fish"

  it "does not remove default procs", ->
    h = R.hashify {}, -> 5
    h.clear()
    expect( h.default_proc() ).toNotEqual null

  describe "1.9", ->
    xit "raises a RuntimeError if called on a frozen instance", ->
      # lambda { HashSpecs.frozen_hash.clear  }.should raise_error(RuntimeError)
      # lambda { HashSpecs.empty_frozen_hash.clear }.should raise_error(RuntimeError)
