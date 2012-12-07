# describe "Integer#ceil", ->
#   it "is an alias to #to_i", ->
#     Proto = RubyJS.Integer.prototype
#     expect( Proto.ceil ).toEqual Proto.to_i

describe "Integer#ceil", ->
  #it_behaves_like(:integer_to_i, :ceil)

  it "returns self", ->
    expect( R( 10 ).ceil() ).toEqual R(10)
    expect( R(-15 ).ceil() ).toEqual R(-15)

  xit 'returns self for bignums', ->
    # expect( R(bignum_value.ceil() ).toEqual (bignum_value)
    # expect( R((-bignum_value).ceil() ).toEqual (-bignum_value)
