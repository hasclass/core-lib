describe "Float#nan?", ->
  it "returns true if self is not a valid IEEE floating-point number", ->
    expect( R.$Float(0.0).nan() ).toEqual false
    expect( R.$Float(-1.5).nan() ).toEqual false
    expect( R.$Float(R.Float.NAN).nan() ).toEqual true
