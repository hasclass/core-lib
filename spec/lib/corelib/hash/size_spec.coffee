describe "Hash#size", ->
  it "returns the number of entries", ->
    expect( R.hashify(a: 1, b: 'c').size() ).toEqual R(2)
    # expect( R.hashify(a: 1, b: 2, a: 2).size() ).toEqual R(2) # not valid coffee
    expect( R.hashify(a: 1, b: 1, c: 1).size() ).toEqual R(3)
    expect( R.hashify({}).size() ).toEqual R(0)
    # expect( R.hashify(5).size() ).toEqual R(0)
    # expect( R.hashify({ 5 }).size() ).toEqual R(0)
