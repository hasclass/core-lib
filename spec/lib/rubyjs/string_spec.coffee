describe "String.isString", ->
  it "should be true for 1, Number, and R(1)", ->
    for val in ["foo", new String("1")]
      expect( R.String.isString( val ) ).toEqual true

  it "should be false for everything else", ->
    for val in [false, true, null, [], 1, new Number(1), {}, undefined]
      expect( R.String.isString( val ) ).toEqual false