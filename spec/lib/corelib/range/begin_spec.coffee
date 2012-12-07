describe 'Range#begin', ->
  it "returns the first element of self", ->
    r = RubyJS.Range.new
    expect( r(-1,1).begin()    ).toEqual  R(-1)
    expect( r(0,1).begin()     ).toEqual  R(0)
    expect( r(0xffff,0xfffff).begin() ).toEqual  R(65535)
    expect( r('Q','T').begin() ).toEqual  R('Q')
    expect( r('Q','T').begin() ).toEqual  R('Q')
    expect( r(0.5,2.4).begin() ).toEqual  R(0.5)
