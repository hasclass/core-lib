describe "Float#+", ->
  it "returns self plus other", ->
    expect( R(491.213).plus(2).unbox()     ).toBeCloseTo 493.213, 0.0001
    expect( R(1001.99).plus(5.219).unbox() ).toBeCloseTo 1007.209, 0.0001

  xit 'unsupported', ->
    #expect( R(9.99).plus bignum_value).toEqual R(9223372036854775808.000)
