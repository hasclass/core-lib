describe "Hash#empty?", ->
  it "returns true if the hash has no entries", ->
    expect( R.hashify({}) .empty()  ).toEqual true
    expect( R.hashify(1: 1).empty() ).toEqual false

  it "returns true if the hash has no entries and has a default value", ->
    expect( R.hashify({}, 5).empty()                    ).toEqual true
    expect( R.hashify({}, -> 5).empty()                 ).toEqual true
    expect( R.hashify({}, (h,k) -> h.set(k,k) ).empty() ).toEqual true
