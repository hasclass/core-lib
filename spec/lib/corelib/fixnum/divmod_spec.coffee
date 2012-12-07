describe "Fixnum#divmod", ->
  it "returns an Array containing quotient and modulus obtained from dividing self by the given argument", ->
    expect( R(13).divmod(4).unbox(true)   ).toEqual [3, 1]
    expect( R(4).divmod(13).unbox(true)   ).toEqual [0, 4]

    expect( R(13).divmod(4.0).unbox(true) ).toEqual [3, 1]
    expect( R(4).divmod(13.0).unbox(true) ).toEqual [0, 4]

    expect( R(1).divmod(2.0).unbox(true)  ).toEqual [0, 1.0]

  xit "bignum", ->
    expect( R(200).divmod(bignum_value).unbox(true)).toEqual [0, 200]

  it "raises a ZeroDivisionError when the given argument is 0", ->
    expect( -> R( 13).divmod(0)    ).toThrow("ZeroDivisionError")
    expect( -> R(  0).divmod(0)    ).toThrow("ZeroDivisionError")
    expect( -> R(-10).divmod(0)    ).toThrow("ZeroDivisionError")

  # ruby_version_is ""..."1.9", ->
  #   it "raises a FloatDomainError when the given argument is 0 and a Float", ->
  #     lambda { 0.divmod(0.0)   }.should raise_error(FloatDomainError)
  #     lambda { 10.divmod(0.0)  }.should raise_error(FloatDomainError)
  #     lambda { -10.divmod(0.0) }.should raise_error(FloatDomainError)
  #   # end

  describe 'ruby_version_is "1.9"', ->
    it "raises a ZeroDivisionError when the given argument is 0 and a Float", ->
      expect( -> R(  0).divmod(R.$Float(0))    ).toThrow("ZeroDivisionError")
      expect( -> R( 10).divmod(R.$Float(0))    ).toThrow("ZeroDivisionError")
      expect( -> R(-10).divmod(R.$Float(0))    ).toThrow("ZeroDivisionError")

  it "raises a TypeError when given a non-Integer", ->
    #obj =
    #  to_int: 10
    #expect( -> R(13)['*'](obj)     ).toThrow("TypeError")
    expect( -> R(13).divmod("10")    ).toThrow("TypeError")
    expect( -> R(13).divmod([])      ).toThrow("TypeError")
