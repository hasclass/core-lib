describe "Range#inspect", ->
  it "provides a printable form, using #inspect to convert the start and end objects", ->
    r = RubyJS.Range.new
    expect( r('A','Z').inspect() ).toEqual  '"A".."Z"'
    expect( r('A','Z', true).inspect() ).toEqual  '"A"..."Z"'
    expect( r( 0,21).inspect() ).toEqual  "0..21"
    expect( r(-8,0).inspect() ).toEqual   "-8..0"
    expect( r(-411,959).inspect() ).toEqual  "-411..959"
    expect( r(0xfff,0xfffff).inspect() ).toEqual  "4095..1048575"
    expect( r(0.5,2.4).inspect() ).toEqual  "0.5..2.4"
