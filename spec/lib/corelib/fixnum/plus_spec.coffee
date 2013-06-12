describe "Fixnum#+", ->
  it "returns self plus the given Integer", ->
    expect( R(491).plus(2)      ).toEqual R(493)
    expect( R(90210).plus(10)   ).toEqual R(90220)
    expect( R(1001).plus(5.219) ).toEqual R(1006.219)

  xit "bignum_value", ->
    (9 + bignum_value).should == 9223372036854775817

  it "raises a TypeError when given a non-Integer", ->
    obj =
      to_int: 10
    expect( -> R(13)['*'](obj)     ).toThrow("TypeError")
    expect( -> R(13).minus("10")    ).toThrow("TypeError")
    expect( -> R(13).minus([])      ).toThrow("TypeError")
