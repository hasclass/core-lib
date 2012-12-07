describe "Float#<=", ->
  it "returns true if self is less than or equal to other", ->
    expect( R(2.0).lteq 3.14159).toEqual true
    expect( R(-2.7183).lteq -24).toEqual false
    expect( R(0.0).lteq 0.0).toEqual true
    expect( R(9235.9).lteq 9999234234423).toEqual true
