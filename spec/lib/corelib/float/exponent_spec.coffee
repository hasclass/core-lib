describe "Float#**", ->
  it "returns self raise to the other power", ->
    expect( R(2.3).exp(3  ).valueOf() ).toBeCloseTo(12.167,0.00001)
    expect( R(5.2).exp(-1 ).valueOf() ).toBeCloseTo(0.192307692307692,0.00001)
    expect( R(9.5).exp(0.5).valueOf() ).toBeCloseTo(3.08220700148449, 0.00001)
    expect( R(9.5).exp(0xffffffff).to_s().valueOf() ).toEqual 'Infinity'

  xdescribe 'ruby_version_is "1.9"', ->
    xit "returns a complex number when negative and raised to a fractional power", ->
      # ((-8.0) ** (1.0/3))      .should be_close(Complex(1, 1.73205), TOLERANCE)
      # ((-8.0) ** Rational(1,3)).should be_close(Complex(1, 1.73205), TOLERANCE)
