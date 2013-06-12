describe "Fixnum#**", ->
  it "returns self raised to the given power", ->
    val = R(2)
    expect(val['**'](0)).toEqual R(1)
    expect(val['**'](1)).toEqual R(2)
    expect(val['**'](2)).toEqual R(4)
    expect(val['**'](40)).toEqual R(1099511627776)
    expect(R(9)['**'](0.5)).toEqual R.$Float(3.0)

  xit "rational", ->
    expect(R(5)['**'](-1).to_f()).toEqual R.$Float('0.2')

  it "overflows the answer to a bignum transparantly", ->
    val = R(2)
    expect( val['**'](29)).toEqual R(536870912)
    expect( val['**'](30)).toEqual R(1073741824)
    expect( val['**'](31)).toEqual R(2147483648)
    expect( val['**'](32)).toEqual R(4294967296)
    expect( val['**'](61)).toEqual R(2305843009213693952)
    expect( val['**'](62)).toEqual R(4611686018427387904)
    expect( val['**'](63)).toEqual R(9223372036854775808)
    expect( val['**'](64)).toEqual R(18446744073709551616)

  it "raises negative numbers to the given power", ->
    val = R(-2)
    expect( val['**'](29)).toEqual R(-536870912)
    expect( val['**'](30)).toEqual R(1073741824)
    expect( val['**'](31)).toEqual R(-2147483648)
    expect( val['**'](32)).toEqual R(4294967296)

    expect( val['**'](61)).toEqual R(-2305843009213693952)
    expect( val['**'](62)).toEqual R(4611686018427387904)
    expect( val['**'](63)).toEqual R(-9223372036854775808)
    expect( val['**'](64)).toEqual R(18446744073709551616)

xdescribe "fixnum", ->
  xit "can raise 1 to a Bignum safely", ->
    #big = bignum_value(4611686018427387904)
    #(1 ** big).should == 1

  xit "can raise -1 to a Bignum safely", ->
    #((-1) ** bignum_value(0)).should equal(1)
    #((-1) ** bignum_value(1)).should equal(-1)

  xit "switches to a Float when the number is too big", ->
    big = bignum_value(4611686018427387904)
    #flt = (2 ** big)
    flt.should be_kind_of(Float)
    flt.infinite?.should == 1

  describe 'conflicts_with :Rational', ->
    # ruby_version_is ""..."1.9", ->
    #   ruby_bug "ruby-dev:32084", "1.8.6.138", ->
    #     it "returns Infinity for 0**-1", ->
    #       (0**-1).should be_kind_of(Float)
    #       (0**-1).infinite?.should == 1

  describe 'ruby_version_is "1.9"', ->
    it "raises a ZeroDivisionError for 0**-1", ->
      expect( -> R(0)['**'](-1) ).toThrow("ZeroDivisionError")

  it "raises a TypeError when given a non-Integer", ->
    expect( -> R(13).minus("10")    ).toThrow("TypeError")
    expect( -> R(13).minus([])      ).toThrow("TypeError")

  xit 'ruby_version_is 1.9', ->
    it "returns a complex number when negative and raised to a fractional power", ->
      #((-8) ** (1.0/3))      .should be_close(Complex(1, 1.73205), TOLERANCE)
      #((-8) ** Rational(1,3)).should be_close(Complex(1, 1.73205), TOLERANCE)
