describe "Fixnum#-", ->
  it "returns self minus the given Integer", ->
    expect( R(5).minus(10)         ).toEqual R(-5)
    expect( R(9237212).minus(5280) ).toEqual R(9231932)
    expect( R(781).minus(0.5)      ).toEqual R(780.5)

  xit "bignum_value", ->
    (2560496 - bignum_value).toEqual R(-9223372036852215312)

  it "raises a TypeError when given a non-Integer", ->
    obj =
      to_int: 10
    expect( -> R(13).minus(obj)     ).toThrow("TypeError")
    expect( -> R(13).minus("10")    ).toThrow("TypeError")
    expect( -> R(13).minus([])      ).toThrow("TypeError")
