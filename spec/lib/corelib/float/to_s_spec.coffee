describe "Float#to_s", ->
  it "returns 'NaN' for NaN", ->
    expect( R.$Float(0.0/0.0).to_s().unbox() ).toEqual 'NaN'

  it "returns 'Infinity' for positive infinity", ->
    expect( R.$Float(1.0/0.0).to_s().unbox() ).toEqual 'Infinity'

  it "returns '-Infinity' for negative infinity", ->
    expect( R.$Float(-1.0/0.0).to_s().unbox() ).toEqual '-Infinity'

  it "returns '0.0' for 0.0", ->
    expect( R.$Float(0.0).to_s().unbox() ).toEqual "0.0"

  it "emits a '-' for negative values", ->
    expect( R.$Float(-3.14).to_s().unbox() ).toEqual "-3.14"

  it "emits a trailing '.0' for a whole number", ->
    expect( R.$Float(50.0).to_s().unbox() ).toEqual "50.0"

  it "uses non-e format for a positive value with fractional part having 5 significant figures", ->
    expect( R.$Float(0.0001).to_s().unbox() ).toEqual "0.0001"

  it "uses non-e format for a negative value with fractional part having 5 significant figures", ->
    expect( R.$Float(-0.0001).to_s().unbox() ).toEqual "-0.0001"

  # ruby_version_is "" ... "1.9", ->
  #   it "uses e format for a positive value with whole part having 16 significant figures", ->
  #     100000000000000.0.to_s().unbox() ).toEqual "1.0e+14"

  #   it "uses e format for a negative value with whole part having 16 significant figures", ->
  #     -100000000000000.0.to_s().unbox() ).toEqual "-1.0e+14"

  # TODO
  xdescribe 'ruby_version_is "1.9"', ->
    it "emits a trailing '.0' for the mantissa in e format", ->
      expect( R.$Float(1.0e20).to_s().unbox() ).toEqual "1.0e+20"

    it "emits '-' for -0.0", ->
      expect( R.$Float(-0.0).to_s().unbox() ).toEqual "-0.0"

    it "uses e format for a positive value with fractional part having 6 significant figures", ->
      expect( R.$Float(0.00001).to_s().unbox() ).toEqual "1.0e-05"

    it "uses e format for a negative value with fractional part having 6 significant figures", ->
      expect( R.$Float(-0.00001).to_s().unbox() ).toEqual "-1.0e-05"

    it "uses non-e format for a positive value with whole part having 15 significant figures", ->
      expect( R.$Float(10000000000000.0).to_s().unbox() ).toEqual "10000000000000.0"

    it "uses non-e format for a negative value with whole part having 15 significant figures", ->
      expect( R.$Float(-10000000000000.0).to_s().unbox() ).toEqual "-10000000000000.0"

    it "uses non-e format for a positive value with whole part having 17 significant figures", ->
      expect( R.$Float(  1000000000000000.0).to_s().unbox() ).toEqual "1000000000000000.0"

    it "uses non-e format for a negative value with whole part having 17 significant figures", ->
      expect( R.$Float( -1000000000000000.0).to_s().unbox() ).toEqual "-1000000000000000.0"

    it "uses e format for a positive value with whole part having 18 significant figures", ->
      expect( R.$Float( 10000000000000000.0).to_s().unbox() ).toEqual "1.0e+16"

    it "uses e format for a negative value with whole part having 18 significant figures", ->
      expect( R.$Float(-10000000000000000.0).to_s().unbox() ).toEqual "-1.0e+16"

  # ruby_bug "#3273", "1.8.7", ->
  #   it "outputs the minimal, unique form necessary to recreate the value", ->
  #     value = 0.21611564636388508
  #     string = "0.21611564636388508"

  #     expect( value.to_s().unbox() ).toEqual string
  #     string.to_f.should == value

  # it "outputs the minimal, unique form to represent the value", ->
  #   expect( 0.56.to_s().unbox() ).toEqual "0.56"
  #