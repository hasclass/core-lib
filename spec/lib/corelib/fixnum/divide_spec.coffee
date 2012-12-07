describe "Fixnum#/", ->
  it "returns self divided by the given argument", ->
    expect( R(2)['/'](2)  ).toEqual R(1)
    expect( R(3)['/'](2)  ).toEqual R(1)

  it "supports dividing negative numbers", ->
    expect(R(-1)['/'](10)).toEqual R(-1)

  it "raises a ZeroDivisionError if the given argument is zero and not a Float", ->
    expect(-> R(1)['/'](0)).toThrow "ZeroDivisionError"

  it "does NOT raise ZeroDivisionError if the given argument is zero and is a Float", ->
    expect(R( 1)['/'](R.$Float(0.0)).to_s() ).toEqual R('Infinity')
    expect(R(-1)['/'](R.$Float(0.0)).to_s() ).toEqual R('-Infinity')

  xit "coerces fixnum and return self divided by other", ->
    #(-1 / 50.4).should be_close(-0.0198412698412698, TOLERANCE)
    #(1 / bignum_value).should == 0

  it "raises a TypeError when given a non-Integer", ->
    expect( -> R(13)['/']("10")  ).toThrow "TypeError"
    expect( -> R(13)['/']([]  )  ).toThrow "TypeError"
