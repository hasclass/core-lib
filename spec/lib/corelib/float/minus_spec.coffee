describe "Float#-", ->
  it "returns self minus other", ->
    expect( R(9237212.5280).minus(5280).unbox()  ).toBeCloseTo 9231932.528, 0.0001
    expect( R(5.5).minus(5.5).unbox()               ).toBeCloseTo 0.0, 0.0001

  xit 'unsupported', ->
    #(2_560_496.1691 - bignum_value).should be_close(-9223372036852215808.000, TOLERANCE)
