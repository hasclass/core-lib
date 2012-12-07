describe "Regexp#source", ->
  it "returns the original string of the pattern", ->
    expect( R(/ab+c/i).source() ).toEqual  R("ab+c")
    expect( R(/x(.)xz/).source() ).toEqual R("x(.)xz")

  it "has working rdocs", ->
    expect( R(/\x20\+/).source() ).toEqual R("\\x20\\+")
    expect( R(/ab+c/i).source()  ).toEqual R("ab+c")