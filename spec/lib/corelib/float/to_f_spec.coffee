describe "Float#to_f", ->
  it "returns self", ->
    expect( R(-500.3).to_f() ).toEqual R( -500.3)
    expect( R(267.51).to_f() ).toEqual R( 267.51)
    expect( R(1.1412).to_f() ).toEqual R( 1.1412)
