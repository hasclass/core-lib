describe "Integer#pred", ->
  it "returns the Integer equal to self - 1", ->
    expect( R(0  ).pred() ).toEqual R(-1)
    expect( R(-1 ).pred() ).toEqual R(-2)
    expect( R(20 ).pred() ).toEqual R(19)

  xit 'unsupported', ->
    expect( R(bignum_value ).pred() ).toEqual R(bignum_value(-1))
