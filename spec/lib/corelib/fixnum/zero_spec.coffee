describe "Fixnum#zero?", ->
  it "returns true if self is 0", ->
    expect( R( 0).zero()  ).toEqual true
    expect( R(-1).zero()  ).toEqual false
    expect( R( 1).zero()  ).toEqual false
