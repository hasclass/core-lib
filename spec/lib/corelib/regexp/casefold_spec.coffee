describe "Regexp#casefold?", ->
  it "returns the value of the case-insensitive flag", ->
    expect( R(/abc/i).casefold() ).toEqual true
    expect( R(/xyz/).casefold()  ).toEqual false
