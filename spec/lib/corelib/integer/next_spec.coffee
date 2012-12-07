describe "Integer#next", ->
  #it_behaves_like(:integer_next, :succ)

  it "returns the next larger positive Fixnum", ->
    expect( R( 2).next() ) .toEqual R(3)

  it "returns the next larger negative Fixnum", ->
    expect( R(-2).next() ).toEqual R(-1)

  xit "returns the next larger positive Bignum", ->
    # bignum_value.next().toEqual R(bignum_value(1))

  xit "returns the next larger negative Bignum", ->
    # (-bignum_value(1)).next().toEqual R(-bignum_value)

  xit "overflows a Fixnum to a Bignum", ->
    # fixnum_max.next().toEqual R(fixnum_max + 1)

  xit "underflows a Bignum to a Fixnum", ->
    # (fixnum_min - 1).next().toEqual R(fixnum_min)
