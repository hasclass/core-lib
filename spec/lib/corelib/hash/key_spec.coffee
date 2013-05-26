# describe "Hash#key?", ->
#   it_behaves_like(:hash_key_p, :key?)
# end

describe "Hash#key", ->
  it "returns the corresponding key for value", ->
    expect( R.hashify(2: 'a', 1: 'b').key('b') ).toEqual '1'

  it "returns nil if the value is not found", ->
    expect( R.hashify(a: -1, b: 3.14, c: 2.718).key('1') ).toEqual null

  it "doesn't return default value if the value is not found", ->
    expect( R.hashify({}, 5).key(5) ).toEqual null

  it "compares values using ==", ->
    expect( R.hashify(1: 0).key(0.0) ).toEqual '1'
    expect( R.hashify(1: 0.0).key(0) ).toEqual '1'

    # TODO:
    # inhash = {'==': -> true}
    # expect( R.hashify(1: inhash).key("foo") ).toEqual '1'
