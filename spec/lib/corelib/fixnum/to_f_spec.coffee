describe "Fixnum#to_f", ->
  it "returns self converted to a Float", ->
    expect( R(0).to_f()      ).toEqual R.$Float(0.0)
    expect( R(-500).to_f()   ).toEqual R.$Float(-500.0)
    expect( R(9641278).to_f()).toEqual R.$Float(9641278.0)
