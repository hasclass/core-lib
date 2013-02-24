describe "Hash#values_at", ->
  it "returns an array of values for the given keys", ->
    h = R.hashify(a: 9, b: 'a', c: -10, d: null)
    expect( h.values_at() ).toBeInstanceOf(R.Array)
    expect( h.values_at() ).toEqual R([])
    expect( h.values_at('a', 'd', 'b') ).toBeInstanceOf(R.Array)
    expect( h.values_at('a', 'd', 'b') ).toEqual R([9, null, 'a'])
