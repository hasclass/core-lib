describe "Float#>", ->
  it "returns true if self is greater than other", ->
    expect( R(1.5).gt 1).toEqual true
    expect( R(2.5).gt 3).toEqual false
    expect( R(45.91).gt 99999999999999).toEqual false
