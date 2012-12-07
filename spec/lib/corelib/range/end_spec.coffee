describe "Range#end", ->
  it "end returns the last element of self", ->
    r = RubyJS.Range.new
    expect( r(-1,1).end()    ).toEqual  R(1)
    expect( r(0,1).end()     ).toEqual  R(1)
    expect( r("A","Q").end() ).toEqual  R("Q")
    expect( r("A","Q").end() ).toEqual  R("Q")
    expect( r(0xffff,0xfffff).end() ).toEqual  R(1048575)
    expect( r(0.5,2.4).end() ).toEqual  R(2.4)

    expect( r(-1,1, true).end()    ).toEqual  R(1)
