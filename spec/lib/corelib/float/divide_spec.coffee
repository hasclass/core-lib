describe "Float#/", ->
  it "returns self divided by other", ->
    expect( R(5.75).divide(-2).valueOf()          ).toBeCloseTo(-2.875, 0.00001)
    expect( R(451.0).to_f().divide(9.3).valueOf() ).toBeCloseTo(48.494623655914, 0.00001)
    expect( R(91.1).divide(-0xffffffff).valueOf() ).toBeCloseTo(-2.12108716418061e-08,  0.00001)

  xit "properly coerces objects", ->
    #expect( R(5.0).divide(FloatSpecs::CanCoerce.new(5)).valueOf() ).toBeCloseTo(0, TOLERANCE)

  it "returns +Infinity when dividing non-zero by zero of the same sign", ->
    expect( R(1.0).to_f().divide(0.0).valueOf()  ).toEqual +R.Float.INFINITY
    expect( R(-1.0).to_f().divide(-0.0).valueOf()).toEqual +R.Float.INFINITY

  it "returns -Infinity when dividing non-zero by zero of opposite sign", ->
    expect( R(1.0).to_f().divide(-0.0).valueOf() ).toEqual -R.Float.INFINITY
    expect( R(-1.0).to_f().divide(0.0).valueOf() ).toEqual -R.Float.INFINITY

  it "returns NaN when dividing zero by zero", ->
    expect( R(0.0).to_f().divide(0.0).nan()  ).toEqual true
    expect( R(-0.0).to_f().divide(0.0).nan() ).toEqual true
    expect( R(0.0).to_f().divide(-0.0).nan() ).toEqual true
    expect( R(-0.0).to_f().divide(-0.0).nan()).toEqual true
