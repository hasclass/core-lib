describe "Array#empty?", ->
  it "returns true if the array has no elements", ->
    expect( R([]    ).empty() ).toEqual true
    expect( R([1]   ).empty() ).toEqual false
    expect( R([1, 2]).empty() ).toEqual false