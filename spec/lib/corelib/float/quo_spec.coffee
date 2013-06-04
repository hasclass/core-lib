describe "Float#quo", ->
  it "performs floating-point division between self and a Fixnum", ->
    expect( R.$Float(8.9).quo(7).valueOf() ).toBeCloseTo 1.2714285714285716, 0.0001

  xit "performs floating-point division between self and a Bignum", ->
    # expect( R.$Float(8.9).quo(9999999999999 ** 9).valueOf() ).toBeCloseTo 8.900000000008011e-117, 0.0001

  it "performs floating-point division between self and a Float", ->
    expect( R.$Float(2827.22).quo(872.111111).valueOf() ).toBeCloseTo 3.2418116961704433, 0.0001

  it "returns NaN when the argument is NaN", ->
    nan_value = 0.0/0.0
    expect( R.$Float(-1819.999999 ).quo(nan_value).nan() ).toEqual true
    expect( R.$Float(11109.1981271).quo(nan_value).nan() ).toEqual true

  it "returns Infinity when the argument is 0.0", ->
    expect( R.$Float(2827.22).quo(0.0).infinite() ).toEqual 1

  it "returns -Infinity when the argument is 0.0 and self is negative", ->
    expect( R.$Float(-48229.282).quo(0.0).infinite() ).toEqual -1

  it "returns Infinity when the argument is 0", ->
    expect( R.$Float(2827.22).quo(0).infinite() ).toEqual 1

  it "returns -Infinity when the argument is 0 and self is negative", ->
    expect( R.$Float(-48229.282).quo(0).infinite() ).toEqual -1

  it "returns 0.0 when the argument is Infinity", ->
    expect( R.$Float(47292.2821).quo(1.0/0.0).valueOf() ).toBeCloseTo 0.0, 0.0001

  it "returns -0.0 when the argument is -Infinity", ->
    expect( R.$Float(1.9999918).quo(-1.0/0.0).valueOf() ).toBeCloseTo -0.0, 0.0001

  xit "performs floating-point division between self and a Rational", ->
    # expect( R.$Float(74620.09).quo(Rational(2,3)).valueOf() ).toBeCloseTo 111930.135, 0.0001

  xit "performs floating-point division between self and a Complex", ->
    # expect( R.$Float(74620.09).quo(Complex(8,2)).valueOf() ).toBeCloseTo Complex(, 0.0001
    #     8778.834117647059, -2194.7085294117646)

  it "raises a TypeError when argument isn't numeric", ->
    expect( -> R.$Float(27292.2).quo([])    ).toThrow('TypeError')

  it "raises an ArgumentError when passed multiple arguments", ->
    expect( -> R.$Float(272.221).quo(6,0.2) ).toThrow('ArgumentError')
