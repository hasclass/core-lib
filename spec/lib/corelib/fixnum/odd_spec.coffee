describe "Fixnum#odd?", ->
  it "is false for zero", ->
    expect( R(0).odd()  ).toEqual false

  it "is false for even positive Fixnums", ->
    expect( R(4).odd()  ).toEqual false

  it "is false for even negative Fixnums", ->
    expect( R(-4).odd() ).toEqual false

  it "is true for odd positive Fixnums", ->
    expect( R(5).odd()  ).toEqual true

  it "is true for odd negative Fixnums", ->
    expect( R(-5).odd() ).toEqual true
