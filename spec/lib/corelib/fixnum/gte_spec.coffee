describe "Fixnum#>=", ->
  it "returns true if self is greater than the given argument", ->
    expect( R(13)['>='](2)      ).toEqual true
    expect( R(-500).gt(-600) ).toEqual true
    expect( R(1)['>='](5)       ).toEqual false
    expect( R(5)['>='](5)       ).toEqual true
    expect( R(5)['>='](4.999)   ).toEqual true

  xit 'bignum_value', ->
    (900 > bignum_value).should == false

  it "raises an ArgumentError when given a non-Integer", ->
    expect( -> R(13)['>=']("10")    ).toThrow("TypeError")
    expect( -> R(13)['>=']([])      ).toThrow("TypeError")
