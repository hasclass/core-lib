describe "Float#<", ->
  it "returns true if self is less than other", ->
    expect( R(71.3).lt 91.8).toEqual true
    expect( R(192.6).lt -500).toEqual false
    expect( R(-0.12).lt 0x4fffffff).toEqual true
