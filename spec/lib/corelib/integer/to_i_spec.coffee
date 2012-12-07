describe "Integer#ceil", ->
  #it_behaves_like(:integer_to_i, :ceil)

  it "returns self", ->
    expect( R( 10 ).to_i() ).toEqual R(10)
    expect( R(-15 ).to_i() ).toEqual R(-15)

  xit 'returns self for bignums', ->
    # expect( R(bignum_value.ceil() ).toEqual (bignum_value)
    # expect( R((-bignum_value).ceil() ).toEqual (-bignum_value)
