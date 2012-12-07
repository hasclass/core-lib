describe "Float#divmod", ->
  it "returns an [quotient, modulus] from dividing self by other", ->
    values = R.$Float(3.14).divmod(2)
    expect( values.at(0) ).toEqual R(1)
    expect( values.at(1).unbox() ).toBeCloseTo(1.14, 0.0001)
    values = R.$Float(2.8284).divmod(3.1415)
    expect( values.at(0) ).toEqual R(0)
    expect( values.at(1).unbox() ).toBeCloseTo(2.8284, 0.0001)
    values = R.$Float(-1.0).divmod(1)
    expect( values.at(0) ).toEqual R(-1)
    expect( values.at(1) ).toEqual R.$Float(0.0)

  xit 'bignum unsupported', ->
    # values = R.$Float(-1.0).divmod(bignum_value)
    # expect( values.at(0) ).toEqual R(-1)
    # expect( values.at(1).unbox() ).toBeCloseTo(9223372036854775808.000, 0.0001)


  # Behaviour established as correct in r23953
  xdescribe 'TODO', ->
    it "raises a FloatDomainError if self is NaN", ->
      expect( -> R.$Float(R.$Float(R.Float.NAN)).divmod(1) ).toThrow('FloatDomainError')

    # Behaviour established as correct in r23953
    it "raises a FloatDomainError if other is NaN", ->
      expect( -> R.$Float(1).divmod(R.$Float(R.Float.NAN)) ).toThrow('FloatDomainError')

    # Behaviour established as correct in r23953
    it "raises a FloatDomainError if self is Infinity", ->
      expect( -> R.$Float(R.$Float(R.Float.INFINITY)).divmod(1) ).toThrow('FloatDomainError')

  # describe 'ruby_version_is ""..."1.9"', ->
  #   it "raises FloatDomainError if other is zero", ->
  #     expect( -> R.$Float(1.0).divmod(0)   ).toThrow('FloatDomainError')
  #     expect( -> R.$Float(1.0).divmod(0.0) ).toThrow('FloatDomainError')

  describe 'ruby_version_is "1.9"', ->
    it "raises a ZeroDivisionError if other is zero", ->
      expect( -> R.$Float(1.0).divmod(0)   ).toThrow('ZeroDivisionError')
      expect( -> R.$Float(1.0).divmod(0.0) ).toThrow('ZeroDivisionError')

  xdescribe 'ruby_bug "redmine #5276", "1.9.2"', ->
    xit "returns the correct [quotient, modulus] even for large quotient", ->
      # 0.59.divmod(7.761021455128987e-11).first.should eql(7602092113)
