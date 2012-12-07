describe "Fixnum#<", ->
  it "returns true if self is greater than the given argument", ->
    expect( R(2)['<'](13)      ).toEqual true
    expect( R(-600)['<'](-500) ).toEqual true
    expect( R(5)['<'](1)       ).toEqual false
    expect( R(5)['<'](5)       ).toEqual false
    expect( R(5)['<'](4.999)   ).toEqual false

  xit 'bignum_value', ->
    (900 < bignum_value).should == truee

  it "raises an ArgumentError when given a non-Integer", ->
    expect( -> R(13)['<']("10")    ).toThrow("TypeError")
    expect( -> R(13)['<']([])      ).toThrow("TypeError")
