describe "Fixnum#succ", ->
  it "returns the next larger positive Fixnum", ->
    expect(R(2).succ()).toEqual R(3)

  it "returns the next larger negative Fixnum", ->
    expect(R(-2).succ()).toEqual R(-1)

  xit "overflows a Fixnum to a Bignum", ->
    expect(R(fixnum_max).succ()).toEqual (fixnum_max + 1)
