describe "Float#%", ->
#describe "Float#modulo", ->
  it "returns self modulo other", ->
    expect( R(6543.21).to_f().modulo(137).valueOf()    ).toBeCloseTo(104.21, 0.00001)
    expect( R(6543.21).to_f().modulo(137.24).valueOf() ).toBeCloseTo(92.9299999999996, 0.00001)
    expect( R(-1.0).to_f().modulo(1).valueOf()         ).toEqual 0

  xit 'unsupported', ->
    # expect( R(5667.19).to_f().modulo(bignum_value).valueOf() ).toBeClose(5667.19, 0.00001)

  it "returns self when modulus is +Infinity", ->
    expect( R(4.2).to_f().modulo(1/0.0).valueOf() ).toEqual 4.2

  it "returns -Infinity when modulus is -Infinity", ->
    expect( R(4.2).to_f().modulo(-1/0.0)).toEqual R(-1/0.0).to_f()

  it "returns NaN when called on NaN or Infinities", ->
    expect( R(0/0.0).to_f().modulo(42).nan()  ).toEqual true
    expect( R(1/0.0).to_f().modulo(42).nan()  ).toEqual true
    expect( R(-1/0.0).to_f().modulo(42).nan() ).toEqual true

  it "returns NaN when modulus is NaN", ->
    expect( R(4.2).to_f().modulo(0/0.0).nan()).toEqual true

  it "returns -0.0 when called on -0.0 with a non zero modulus", ->
    # r = R(-0.0).to_f().modulo(42)
    # expect( r.valueOf() ).toEqual 0
    # expect( 1 / r.valueOf() ).should < 0

    # r = (-0.0).to_f()).modulo((1/0.0))
    # r.toEqual 0
    # (1/r).should < 0

  # ruby_version_is ""..."1.9", ->
  #   it "does NOT raise ZeroDivisionError if other is zero", ->
  #     1.0).to_f().modulo(0).should be_nan
  #     1.0).to_f().modulo(0.0).should be_nan

  describe 'ruby_version_is "1.9"', ->
    it "raises a ZeroDivisionError if other is zero", ->
      expect( -> R(1.0).to_f().modulo(0)  ).toThrow('ZeroDivisionError')
      expect( -> R(1.0).to_f().modulo(0.0)  ).toThrow('ZeroDivisionError')
