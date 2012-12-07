describe "Fixnum#even?", ->
  it "is true for zero", ->
    expect( R(0).even() ).toEqual true

  it "is true for even positive Fixnums", ->
    expect( R(4).even() ).toEqual true

  it "is true for even negative Fixnums", ->
    expect( R(-4).even()).toEqual true

  it "is false for odd positive Fixnums", ->
    expect( R(5).even()   ).toEqual false

  it "is false for odd negative Fixnums", ->
    expect( R(-5).even()).toEqual false
