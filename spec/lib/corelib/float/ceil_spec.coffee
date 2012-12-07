describe "Float#ceil", ->
  it "returns the smallest Integer greater than or equal to self", ->
    expect( R(-1.2 ).to_f().ceil() ).toEqual(R -1)
    expect( R(-1.0 ).to_f().ceil() ).toEqual(R -1)
    expect( R(0.0 ).to_f().ceil() ).toEqual(R 0 )
    expect( R(1.3 ).to_f().ceil() ).toEqual(R 2 )
    expect( R(3.0 ).to_f().ceil() ).toEqual(R 3 )
    expect( R(-9223372036854775808.1).ceil() ).toEqual(R -9223372036854775808)
    expect( R(+9223372036854775808.1).ceil() ).toEqual(R +9223372036854775808)
