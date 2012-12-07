describe "RubyJS boxing/unboxing", ->
  it "2 + 3 = 5", ->
    expect(2 + 3).toEqual 5
    expect(R(2) + 3).toEqual 5
    expect(3 + R(2)).toEqual  5
    expect(+R(2) + 3).toEqual 5

  it "5 - 3 = 2", ->
    expect(5 - 3).toEqual 2
    expect(R(5) - 3).toEqual 2
    expect(+R(5) - 3).toEqual 2
    expect(3 - R(5)).toEqual -2

  it "6 / 3 = 2", ->
    expect(     6  / 3).toEqual 2
    expect( R(6) / 3).toEqual 2
    expect(+R(6) / 3).toEqual 2
    expect(+R(6) / 4).toEqual 1.5
    # Ruby divides integers differently
    expect(R(6)['/'] 4).toEqual R(1)

  it "R._int == int", ->
    expect(      6  == 3).toEqual false
    expect(  R(6) == 3).toEqual false
    expect( +R(6) == 3).toEqual false

    expect(      6  == 6).toEqual true
    expect( +R(6) == 6).toEqual true
    expect( 6 == +R(6)).toEqual true
    # BUT:
    expect(  R(6) == 6).toEqual false
    expect(  6 == R(6)).toEqual false
    # Just like JS:
    expect( new Number(6) == 6).toEqual false
    expect( new Number(6) == new Number(6)).toEqual false


  it "R._int <= int", ->
    expect(     6  <= 3).toEqual false
    expect(     3  <= 6).toEqual true

    expect( R(6) <= 3).toEqual false
    expect( R(3) <= 6).toEqual true
    expect( R(15) >= 6).toEqual true
    # make sure >= doesnt check just the first number
    expect( +R(35) >= 6).toEqual true
    # because the following holds true
    expect( "35" >= 6).toEqual true
    expect( 3 <= R(6)).toEqual true

  it "string <= string", ->
    expect(     '6'  <= '3').toEqual false
    expect( R('6') <= '3').toEqual false

    expect(     '3'  <= '6').toEqual true
    expect( R('3') <= '6').toEqual true
    expect( '3' <= R('6')).toEqual true

  it "boxing 1.0, 0.0 floats", ->
    expect( R(1) ).toEqual R.$Integer(1)
    # in ruby 1.0 would return a float
    expect( R(1.0) ).toNotEqual R.$Float(1)
    # therefore box 1.0 explicitely
    expect( R.$Float(1.0) ).toEqual R.$Float(1)

  xit "boxing", ->
    expect( R('hello') ).toEqual RubyJS.String('hello')

