describe "String#to_f", ->
  it "treats leading characters of self as a floating point number", ->
    expect(R("123.45e1").to_f()).toEqual(R.$Float 1234.5)
    expect(R("45.67 degrees").to_f()).toEqual(R.$Float 45.67)
    expect(R("0").to_f()).toEqual(R.$Float 0.0)
    expect(R("123.45e1").to_f()).toEqual(R.$Float 1234.5)

    expect(R(".5").to_f()).toEqual(R.$Float 0.5)
    expect(R(".5e1").to_f()).toEqual(R.$Float 5.0)

  # expect(R("5e").to_f()).toEqual(R.$Float 5.0)
  # expect(R("5E").to_f()).toEqual(R.$Float 5.0)

  it "treats special float value strings as characters", ->
    expect(R("NaN").to_f()          ).toEqual(R.$Float 0.0)
    expect(R("Infinity").to_f()     ).toEqual(R.$Float 0.0)
    expect(R("-Infinity").to_f()    ).toEqual(R.$Float 0.0)
    expect(R("Inf").to_f()          ).toEqual(R.$Float 0.0)
    expect(R("-Inf").to_f()         ).toEqual(R.$Float 0.0)

  it "allows for varying case", ->
    expect(R("123.45e1").to_f()).toEqual(R.$Float 1234.5)
    expect(R("123.45E1").to_f()).toEqual(R.$Float 1234.5)

  it "allows for varying signs", ->
    expect(R("+123.45e1").to_f()    ).toEqual(R.$Float +123.45e1)
    expect(R("-123.45e1").to_f()    ).toEqual(R.$Float -123.45e1)
    expect(R("123.45e+1").to_f()    ).toEqual(R.$Float 123.45e+1)
    expect(R("123.45e-1").to_f()    ).toEqual(R.$Float 123.45e-1)
    expect(R("+123.45e+1").to_f()   ).toEqual(R.$Float +123.45e+1)
    expect(R("+123.45e-1").to_f()   ).toEqual(R.$Float +123.45e-1)
    expect(R("-123.45e+1").to_f()   ).toEqual(R.$Float -123.45e+1)
    expect(R("-123.45e-1").to_f()   ).toEqual(R.$Float -123.45e-1)

  it "allows for underscores, even in the decimal side", ->
    expect(R("1_234_567.890_1").to_f()).toEqual(R.$Float 1234567.8901)

  it "returns 0.0 for strings with any non-digit in them", ->
    expect(R("blah").to_f()         ).toEqual(R.$Float 0.0)
    expect(R("0b5" ).to_f()         ).toEqual(R.$Float 0.0)
    expect(R("0d5" ).to_f()         ).toEqual(R.$Float 0.0)
    expect(R("0o5" ).to_f()         ).toEqual(R.$Float 0.0)
    expect(R("0xx5").to_f()         ).toEqual(R.$Float 0.0)

  # TODO: check the following two specs with rubyspec, which differ
  it "returns 0.0 for strings with leading underscores", ->
    # expect(R("_9").to_f()).toEqual(R.$Float 0.0)

  it "ignores leading underscores", ->
    # expect( R("_9").to_f() ).toEqual( R.$Float 9.0 )

  it "takes an optional sign", ->
    expect(R("-45.67 degrees").to_f()).toEqual(R.$Float -45.67)
    expect(R("+45.67 degrees").to_f()).toEqual(R.$Float 45.67)
    # expect(R("-5_5e-5_0").to_f()).toEqual(R.$Float -55e-50)
    expect(R("-").to_f()).toEqual(R.$Float 0.0)
    # expect(R((1.0 / "-0").to_f()).to_s()).toEqual(R.$Float "-Infinity")

  xit "TODO", ->
    expect(R("_9").to_f()).toEqual(R.$Float 0.0)
    expect( R("_9").to_f() ).toEqual( R.$Float 9.0 )
    expect(R("-5_5e-5_0").to_f()).toEqual(R.$Float -55e-50)
    expect(R((1.0 / "-0").to_f()).to_s()).toEqual(R.$Float "-Infinity")

  it "returns 0.0 if the conversion fails", ->
    expect(R("bad").to_f()).toEqual(R.$Float 0.0)
    expect(R("thx1138").to_f()).toEqual(R.$Float 0.0)

  it "returns 0.0 for strings represented as hex", ->
    expect(R("0x1").to_f()).toEqual(R.$Float 0.0)
    expect(R("0x30").to_f()).toEqual(R.$Float 0.0)
    expect(R(" _0x1").to_f()).toEqual(R.$Float 0.0)
