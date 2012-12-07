describe "Float#floor", ->
  it "returns the largest Integer less than or equal to self", ->
    expect( R( -1.2 ).to_f().floor() ).toEqual(R -2)
    expect( R( -1.0 ).to_f().floor() ).toEqual(R -1)
    expect( R(  0.0 ).to_f().floor() ).toEqual(R 0 )
    expect( R(  1.0 ).to_f().floor() ).toEqual(R 1 )
    expect( R(  5.9 ).to_f().floor() ).toEqual(R 5 )
    expect( R(-9223372036854775808.1).floor() ).toEqual(R -9223372036854775808)
    expect( R(+9223372036854775808.1).floor() ).toEqual(R +9223372036854775808)
