describe "Hash#keys", ->
  it "returns an array with the keys in the order they were inserted", ->
    new_hash = R.hashify({})
    expect( new_hash.keys() ).toEqual R([])
    expect( new_hash.keys() ).toBeInstanceOf R.Array

    expect( R.hashify({}, 5).keys()     ).toEqual R([])
    expect( R.hashify({}, -> 5 ).keys() ).toEqual R([])

    # HASH unordered keys
    expect( R.hashify(1: 2, 4: 8, 2: 4).keys() ).toEqual R(['1', '2', '4'])
    expect( R.hashify(1: 2, 2: 4, 4: 8).keys() ).toBeInstanceOf R.Array

    expect( R.hashify(null: null).keys() ).toEqual R(['null'])


  it "it uses the same order as #values", ->
    h = R.hashify(1: "1", 2: "2", 4: "4", 3: "3")

    h.size().times (i) ->
      expect( h.get(h.keys().get(i)) ).toEqual h.values().get(i)
