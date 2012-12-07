describe "Float#finite?", ->
  it "returns true for finite values", ->
    expect( R.$Float( 3.14159).finite() ).toEqual true

  it "returns false for positive infinity", ->
    expect( R.$Float( R.Float.INFINITY).finite() ).toEqual false

  it "returns false for negative infinity", ->
    expect( R.$Float( -R.Float.INFINITY).finite() ).toEqual false

  it "returns false for NaN", ->
    expect( R.$Float( R.Float.NAN).finite()  ).toEqual false
