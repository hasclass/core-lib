describe "Hash#has_value?", ->

  it "returns true if the value exists in the hash", ->
    expect( R.hashify(a: 'b').has_value('a') ).toEqual false
    expect( R.hashify(1: 2).has_value(2) ).toEqual true
    # h = R.hashify 5
    # expect( h.has_value(5) ).toEqual false
    # h = R.hashify { 5 }
    # expect( h.has_value(5) ).toEqual false

  it "uses == semantics for comparing values", ->
    expect( R.hashify(5: 2.0).has_value(2) ).toEqual true
    expect( R.hashify(5: 2.0).has_value('2') ).toEqual false

# DEBT test for rubyjs typecasted objects