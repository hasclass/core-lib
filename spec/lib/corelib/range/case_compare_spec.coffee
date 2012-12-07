describe "Range#===", ->
  it "returns true if other is an element of self", ->
    r = RubyJS.Range.new
    expect( r(0,5).equal_case(2)      ).toEqual  true
    expect( r(0,5).equal_case(0)      ).toEqual  true
    expect( r(-5,5).equal_case(0)     ).toEqual  true
    expect( r(-1,1, true).equal_case(10.5)  ).toEqual  false
    expect( r(-10,-2).equal_case(-2.5)).toEqual  true
    expect( r('C','X').equal_case('M')).toEqual  true
    expect( r('C','X').equal_case('A')).toEqual  false
    expect( r('B','W', true).equal_case('W')).toEqual  false
    expect( r('B','W', true).equal_case('Q')).toEqual  true
    expect( r(0xffff,0xfffff).equal_case(0xffffd)).toEqual  true
    expect( r(0xffff,0xfffff).equal_case(0xfffd) ).toEqual  false
    expect( r(0.5,2.4).equal_case(2)  ).toEqual  true
    expect( r(0.5,2.4).equal_case(2.5)).toEqual  false
    expect( RubyJS.Range.new(0.5,2.4).equal_case(2.4)).toEqual  true
    expect( r(0.5,2.4, true).equal_case(2.4)).toEqual  false

  xit "compares values using <=>", ->
    rng = RubyJS.Range.new(1,5)
    m = R(1)
    m.coerce = -> [1, 2]
    m['<=>'] = -> 1

    expect( rng.equalss(m) ).toEqual false
