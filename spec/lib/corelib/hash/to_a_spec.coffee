describe "Hash#to_a", ->
  it "returns a list of [key, value] pairs with same order as each()", ->
    h = R.hashify(a: 1, 1: 'a', 3: 'b', b: 5)
    pairs = []

    h.each_pair (key, value) -> pairs.push([key, value])

    expect( h.to_a() ).toBeInstanceOf(R.Array)
    expect( h.to_a() ).toEqual R(pairs)

  it "is called for Enumerable#entries", ->
    h = R.hashify(a: 1, 1: 'a', 3: 'b', b: 5)
    pairs = []

    h.each_pair (key, value) -> pairs.push([key, value])

    expect( h.entries() ).toBeInstanceOf(R.Array)
    expect( h.entries() ).toEqual R(pairs)
