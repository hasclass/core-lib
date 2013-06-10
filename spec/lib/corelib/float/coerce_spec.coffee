describe "Float#coerce", ->
  it "returns [other, self] both as Floats", ->
    expect( new R.Float( 1.2  ).coerce(1    ).valueOf(true) ).toEqual [1.0, 1.2]
    expect( new R.Float( 5.28 ).coerce(1.0  ).valueOf(true) ).toEqual [1.0, 5.28]
    expect( new R.Float( 1.0  ).coerce(1    ).valueOf(true) ).toEqual [1.0, 1.0]
    expect( new R.Float( 1.0  ).coerce("2.5").valueOf(true) ).toEqual [2.5, 1.0]
    expect( new R.Float( 1.0  ).coerce(3.14 ).valueOf(true) ).toEqual [3.14, 1.0]

  xit 'bignum unsupported', ->
    # a, b = -0.0.coerce(bignum_value)
    # a.should be_close(9223372036854775808.0, TOLERANCE)
    # b.should be_close(-0.0, TOLERANCE)
    # a, b = 1.0.coerce(bignum_value)
    # a.should be_close(9223372036854775808.0, TOLERANCE)
    # b.should be_close(1.0, TOLERANCE)
