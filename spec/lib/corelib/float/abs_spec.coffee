describe "Float#abs", ->
  #it_behaves_like(:float_abs, :abs)
  it "returns the absolute value", ->
    expect( R(-99.1).abs() ).toEqual R(99.1).to_f()
    expect( R(4.5).abs() ).toEqual R(4.5).to_f()
    expect( R(0.0).to_f().abs() ).toEqual R(0.0).to_f()

  it "returns 0.0 if -0.0", ->
    expect( R(-0.0).to_f().abs() ).toEqual R(+0.0).to_f()

  it "returns Infinity if -Infinity", ->
    expect( R(-R.Float.INFINITY).abs().infinite() ).toEqual 1

  # TODO NaN.abs == NaN
  xit "returns NaN if NaN", ->
    expect( R.$Float(R.Float.NAN).abs().nan() ).toEqual true
