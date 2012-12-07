describe "Numeric.isNumeric", ->
  it "should be true for 1, Number, and R(1)", ->
    expect( R.Numeric.isNumeric( 1 ) ).toEqual true
    expect( R.Numeric.isNumeric( new Number(1) ) ).toEqual true
    expect( R.Numeric.isNumeric( R(1) ) ).toEqual true

  it "should be false for everything else", ->
    for val in [false, true, null, [], "1", new String("1"), {}, undefined]
      expect( R.Numeric.isNumeric( val ) ).toEqual false