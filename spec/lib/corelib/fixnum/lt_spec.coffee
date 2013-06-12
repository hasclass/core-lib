describe "Fixnum#<", ->
  it "returns true if self is greater than the given argument", ->
    expect( R(2)['lt'](13)      ).toEqual true
    expect( R(-600)['lt'](-500) ).toEqual true
    expect( R(5)['lt'](1)       ).toEqual false
    expect( R(5)['lt'](5)       ).toEqual false
    expect( R(5)['lt'](4.999)   ).toEqual false

  xit 'bignum_value', ->
    (900 < bignum_value).should == truee

  it "raises an ArgumentError when given a non-Integer", ->
    expect( -> R(13)['lt']("10")    ).toThrow("TypeError")
    expect( -> R(13)['lt']([])      ).toThrow("TypeError")
