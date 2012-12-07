describe "String#size", ->
  # it_behaves_like(:string_length, :size)
  it "returns the length of self", ->
    expect( R(""     ).size().equals 0).toEqual true
    expect( R("\x00" ).size().equals 1).toEqual true
    expect( R("one"  ).size().equals 3).toEqual true
    expect( R("two"  ).size().equals 3).toEqual true
    expect( R("three").size().equals 5).toEqual true
    expect( R("four" ).size().equals 4).toEqual true
