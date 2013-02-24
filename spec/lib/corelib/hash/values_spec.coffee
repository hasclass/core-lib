describe "Hash#values", ->
  it "returns an array of values", ->
    h = R.hashify({1: 'a', 'a': 'a', 'the': 'lang'})
    expect( h.values() ).toBeInstanceOf(R.Array)
    expect( h.values().sort() ).toEqual R(['a', 'a', 'lang'])
