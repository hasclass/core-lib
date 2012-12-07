describe "Range#equal", ->
  it "returns true if other has same begin, end, and exclude_end? values", ->
    r = RubyJS.Range.new
    expect( r(0,    2).equals( r( 0,2    ) ) ).toEqual  true
    expect( r('G','M').equals( r( 'G','M') ) ).toEqual  true
    expect( r(0.5,2.4).equals( r( 0.5,2.4) ) ).toEqual  true
    expect( r(5,   10).equals( r(5,10    ) ) ).toEqual  true
    expect( r('D','V').equals( r('D','V' ) ) ).toEqual  true
    expect( r(0.5,2.4).equals( r(0.5, 2.4) ) ).toEqual  true
    expect( r(0xffff,0xfffff).equals( r(0xffff,0xfffff)) ).toEqual  true
    expect( r(0xffff,0xfffff).equals( r(0xffff,0xfffff)) ).toEqual  true
    expect( r('Q','X' ).equals( r('A','C' ))  ).toEqual  false
    expect( r('Q','X' ).equals( r('Q', 'W'))  ).toEqual  false
    expect( r('Q', 'X').equals( r('Q','X', true))  ).toEqual  false
    expect( r(0.5, 2.4).equals( r(0.5, 2.4, true))  ).toEqual  false
    expect( r(1482, 1911, true).equals( r( 1482, 1911))  ).toEqual  false
    expect( r(0xffff, 0xfffff, true).equals(  r(0xffff, 0xfffff))  ).toEqual  false

  it "returns false if other is no Range", ->
    r = RubyJS.Range.new
    expect( r(1, 10).equals( 1) ).toEqual  false
    expect( r(1, 10).equals( 'a') ).toEqual  false
    expect( r(1, 10).equals( {} ) ).toEqual  false

  describe 'ruby_version_is "1.9"', ->
    xit "returns true for subclasses to Range", ->
      # class MyRange < Range ; end
      # Range.new(1, 2).send(@method, MyRange.new(1, 2)) ).toEqual  true
