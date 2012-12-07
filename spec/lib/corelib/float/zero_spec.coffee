describe "Float#zero?", ->
  it "returns true if self is 0.0", ->
    expect( R(0.0).to_f().zero() ).toEqual true
    expect( R(1.0).to_f().zero() ).toEqual false
    expect( R(-1.0).to_f().zero() ).toEqual false
