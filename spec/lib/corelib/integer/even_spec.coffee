describe "Integer#even?", ->
  it "returns true when self is an even number", ->
    expect( R(-2).even() ).toEqual true
    expect( R(-1).even() ).toEqual false

    expect( R(0).even() ).toEqual true
    expect( R(1).even() ).toEqual false
    expect( R(2).even() ).toEqual true

  xit 'unsupported', ->
    # bignum_value(0).even?.should be_true
    # bignum_value(1).even?.should be_false

    # (-bignum_value(0)).even?.should be_true
    # (-bignum_value(1)).even?.should be_false
