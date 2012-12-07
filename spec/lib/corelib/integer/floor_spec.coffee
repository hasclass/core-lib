
# describe "Integer#floor", ->
#   #   it_behaves_like(:integer_to_i, :floor)
#   it "is an alias to #to_i", ->
#     Proto = RubyJS.Integer.prototype
#     expect( Proto.floor ).toEqual Proto.to_i


describe "Integer#floor", ->
  #it_behaves_like(:integer_to_i, :floor)

  it "returns self", ->
    expect( R( 10 ).floor() ).toEqual R(10)
    expect( R(-15 ).floor() ).toEqual R(-15)

  xit 'returns self for bignums', ->
    # expect( R(bignum_value.floor() ).toEqual (bignum_value)
    # expect( R((-bignum_value).floor() ).toEqual (-bignum_value)
