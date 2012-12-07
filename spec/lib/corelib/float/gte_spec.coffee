describe "Float#>=", ->
  it "returns true if self is greater than or equal to other", ->
    expect( R(5.2).gteq 5.2).toEqual true
    expect( R(9.71).gteq 1).toEqual true
    expect( R(5.55382).gteq 0xfabdafbafcab).toEqual false
