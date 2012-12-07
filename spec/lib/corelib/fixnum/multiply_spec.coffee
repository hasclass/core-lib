describe "Fixnum#*", ->
  it "returns self multiplied by the given Integer", ->
    expect(R(4923)['*'](2)).toEqual R(9846)
    expect(R(1342177)['*'](800)).toEqual R(1073741600)
    expect(R(65536)['*'](65536)).toEqual R(4294967296)
    expect(R(6712)['*'](0.25)).toEqual R(1678.0)

  xit "bignum_value", ->
    (256 * bignum_value).should == 2361183241434822606848

  it "raises a TypeError when given a non-Integer", ->
    obj =
     to_int: 10
    expect( -> R(13)['*'](obj)     ).toThrow("TypeError")
    expect( -> R(13)['*']("10")    ).toThrow("TypeError")
    expect( -> R(13)['*']([])      ).toThrow("TypeError")

  xit "overflows to Bignum when the result does not fit in Fixnum", ->
    if 1.size == 4
      # 32-bit fixnums
      y = 0x4000
      result = y * y * y
      result.should == 0x40000000000
      result.should be_kind_of(Bignum)
    # errors:
    #elsif 1.size == 8
    #  # 64-bit fixnums
    #  y = 0x40000000
    #  result = y * y * y
    #  result.should == 0x40000000000000000000000
    #  result.should be_kind_of(Bignum)
