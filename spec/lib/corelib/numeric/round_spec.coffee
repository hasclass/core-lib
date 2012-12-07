describe "Numeric#round", ->
  it "converts self to a Float (using #to_f) and returns the #round'ed result", ->
    obj = new R.Numeric
    obj.to_f = -> R(2.3)
    expect( obj.round() ).toEqual R(2)
    obj.to_f = -> R(-2.3)
    expect( obj.round() ).toEqual R(-2)
