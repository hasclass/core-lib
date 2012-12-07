describe "Fixnum#modulo", ->
  it "returns the modulus obtained from dividing self by the given argument", ->
    expect( R(13).modulo(4)     ).toEqual R(1)
    expect( R(4).modulo(13)     ).toEqual R(4)

    expect( R(13).modulo(4.0)   ).toEqual R(1)
    expect( R(4).modulo(13.0)   ).toEqual R(4)

    expect( R(-200).modulo(256)  ).toEqual R(56)
    expect( R(-1000).modulo(512) ).toEqual R(24)

    expect( R(-200).modulo(-256) ).toEqual R(-200)
    expect( R(-1000).modulo(-512)).toEqual R(-488)

    expect( R(200).modulo(-256)  ).toEqual R(-56)
    expect( R(1000).modulo(-512) ).toEqual R(-24)

    expect( R(1).modulo(R.$Float(2.0))     ).toEqual R.$Float(1.0)

  xit "bignum_value", ->
    expect( R(200).modulo(bignum_value)).toEqual R(200)

  it "raises a ZeroDivisionError when the given argument is 0", ->
    expect( -> R(13).modulo(0)  ).toThrow "ZeroDivisionError"
    expect( -> R( 0).modulo(0)  ).toThrow "ZeroDivisionError"
    expect( -> R(-10).modulo(0) ).toThrow "ZeroDivisionError"

  # ruby_version_is ""..."1.9", ->
  #   it "does not raise a FloatDomainError when the given argument is 0 and a Float", ->
  #     0.send(@method, 0.0).to_s.should == "NaN"
  #     10.send(@method, 0.0).to_s.should == "NaN"
  #     -10.send(@method, 0.0).to_s.should == "NaN"

  describe 'ruby_version_is "1.9"', ->
    it "raises a ZeroDivisionError when the given argument is 0 and a Float", ->
      expect( -> R(0).modulo(R.$Float(0.0))   ).toThrow "ZeroDivisionError"
      expect( -> R(10).modulo(R.$Float(0.0))  ).toThrow "ZeroDivisionError"
      expect( -> R(-10).modulo(R.$Float(0.0)) ).toThrow "ZeroDivisionError"

  it "raises a TypeError when given a non-Integer", ->
    expect( -> R(13).modulo("10")    ).toThrow("TypeError")
    expect( -> R(13).modulo([])      ).toThrow("TypeError")
