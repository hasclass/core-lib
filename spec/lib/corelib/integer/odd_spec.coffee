describe "Integer#odd?", ->
  it "returns true when self is an odd number", ->
    expect( R(-2).odd() ).toEqual false
    expect( R(-1).odd() ).toEqual true

    expect( R(0).odd() ).toEqual false
    expect( R(1).odd() ).toEqual true
    expect( R(2).odd() ).toEqual false

  xit 'unsupported', ->
    # bignum_value(0).odd?.should be_false
    # bignum_value(1).odd?.should be_true

    # (-bignum_value(0)).odd?.should be_false
    # (-bignum_value(1)).odd?.should be_true
