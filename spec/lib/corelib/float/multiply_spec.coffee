describe "Float#*", ->
  it "returns self plus other", ->
    expect( R(4923.98221).multiply(2).unbox() ).toBeCloseTo 9847.96442, 0.0001
    expect( R(6712.5).multiply(0.25).unbox()  ).toBeCloseTo 1678.125, 0.0001

  xit 'unsupported', ->
    # (256.4096 * bignum_value).should be_close(2364961134621118431232.000, TOLERANCE)
