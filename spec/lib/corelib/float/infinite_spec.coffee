describe "Float#infinite?", ->
  it "returns nil for finite values", ->
    expect( R.$Float(1.0).infinite() ).toEqual null

  it "returns 1 for positive infinity", ->
    expect( R.$Float(R.Float.INFINITY).infinite() ).toEqual 1

  it "returns -1 for negative infinity", ->
    expect( R.$Float(-R.Float.INFINITY).infinite() ).toEqual -1

  it "returns nil for NaN", ->
    expect( R.$Float(R.Float.NAN).infinite() ).toEqual null
