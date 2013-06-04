describe "Kernel.Float", ->
  it "returns the identical Float for numeric Floats", ->
    float  = R 1.12
    float2 = R.$Float(float)
    float3 = R 1.12
    expect( float2 is float ).toEqual true
    expect( float3 is float ).toEqual false
    #expect( float2.object_id).toEqual float.object_id

  it "returns a Float for Fixnums", ->
    expect( R.$Float(    1 ) ).toEqual R.$Float(1.0)
    expect( R.$Float(R(1)) ).toEqual R.$Float(1.0)
  # xit "returns a Float for Bignums", ->
  #   # expect( R.$Float(1000000000000)).toEqual 1000000000000.0

  it "raises an TypeError for nil", ->
    expect( -> R.$Float(null) ).toThrow "TypeError"

  # it "returns the identical NaN for NaN", ->
  #   nan = nan_value
  #   nan.nan?.should be_true
  #   nan2 = R.$Float(nan)
  #   nan2.nan?.should be_true
  #   expect( nan2).toEqual(nan)

  # it "returns the same Infinity for Infinity", ->
  #   infinity = infinity_value
  #   infinity2 = R.$Float(infinity)
  #   expect( infinity2 ).toEqual infinity_value
  #   expect( infinity  ).toEqual(infinity2)

  it "converts Strings to floats without calling #to_f", ->
    string = R "10"
    #spyOn(string)
    expect( R.$Float(string).is_float? ).toEqual true
    expect( R.$Float(string).valueOf() ).toEqual 10.0
    #expect( string.to_f ).toNotHaveBeenCalled()

  it "converts Strings with decimal points into Floats", ->
    expect( R.$Float("10.0") ).toEqual R.$Float(10.0)

  xit "strips String before converting Strings with decimal points into Floats", ->
    expect( R.$Float(" 10.0 ") ).toEqual R.$Float(10.0)

  it "raises an ArgumentError for a String of word characters", ->
    expect( -> R.$Float("float") ).toThrow "ArgumentError"

  it "raises an ArgumentError if there are two decimal points in the String", ->
    expect( -> R.$Float("10.0.0") ).toThrow "ArgumentError"

  it "raises an ArgumentError for a String of numbers followed by word characters", ->
    expect( -> R.$Float("10D") ).toThrow "ArgumentError"

  it "raises an ArgumentError for a String of word characters followed by numbers", ->
    expect( -> R.$Float("D10") ).toThrow "ArgumentError"

  it "is strict about the string form even across newlines", ->
    expect( -> R.$Float("not a number\n10") ).toThrow "ArgumentError"
    expect( -> R.$Float("10\nnot a number") ).toThrow "ArgumentError"

#   it "converts String subclasses to floats without calling #to_f", ->
#     my_string = Class.new(String) do
#       def to_f() 1.2
#     expect( R.$Float(my_string.new("10"))).toEqual 10.0

  it "returns a positive Float if the string is prefixed with +", ->
    expect( R.$Float("+10")).toEqual  R.$Float(10.0)
    expect( R.$Float(" +10")).toEqual R.$Float(10.0)

  it "returns a negative Float if the string is prefixed with -", ->
    expect( R.$Float("-10")).toEqual  R.$Float(-10.0)
    expect( R.$Float(" -10")).toEqual R.$Float(-10.0)

  it "raises an ArgumentError if a + or - is embedded in a String", ->
    expect( -> R.$Float("1+1") ).toThrow "ArgumentError"
    expect( -> R.$Float("1-1") ).toThrow "ArgumentError"

  it "raises an ArgumentError if a String has a trailing + or -", ->
    expect( -> R.$Float("11+") ).toThrow "ArgumentError"
    expect( -> R.$Float("11-") ).toThrow "ArgumentError"

  it "raises an ArgumentError for a String with a leading _", ->
    expect( -> R.$Float("_1") ).toThrow "ArgumentError"

  it "returns a value for a String with an embedded _", ->
    expect( R.$Float("1_000")).toEqual R.$Float(1000.0)

  xit "raises an ArgumentError for a String with a trailing _", ->
    expect( -> R.$Float("10_") ).toThrow "ArgumentError"

  xit "raises an ArgumentError for a String of \\0", ->
    # expect( -> R.$Float("\0") ).toThrow "ArgumentError"

  xit "raises an ArgumentError for a String with a leading \\0", ->
    # expect( -> R.$Float("\01") ).toThrow "ArgumentError"

  xit "raises an ArgumentError for a String with an embedded \\0", ->
    # expect( -> R.$Float("1\01") ).toThrow "ArgumentError"

  xit "raises an ArgumentError for a String with a trailing \\0", ->
    # expect( -> R.$Float("1\0") ).toThrow "ArgumentError"

  it "raises an ArgumentError for a String that is just an empty space", ->
    expect( -> R.$Float(" ") ).toThrow "ArgumentError"

  it "raises an ArgumentError for a String that with an embedded space", ->
    expect( -> R.$Float("1 2") ).toThrow "ArgumentError"

  it "returns a value for a String with a leading space", ->
    expect( R.$Float(" 1") ).toEqual R.$Float(1.0)

  it "returns a value for a String with a trailing space", ->
    expect( R.$Float("1 ")).toEqual R.$Float(1.0)

  for e in ['e', 'E']
    it "raises an ArgumentError if #{e} is the trailing character", ->
      expect( -> R.$Float("2#{e}") ).toThrow "ArgumentError"

    it "raises an ArgumentError if #{e} is the leading character", ->
      expect( -> R.$Float("#{e}2") ).toThrow "ArgumentError"

#     it "returns Infinity for '2#{e}1000'", ->
#       expect( R.$Float("2#{e}1000")).toEqual (1.0/0)

    # it "returns 0 for '2#{e}-1000'", ->
    #   expect( R.$Float("2#{e}-1000")).toEqual 0

    it "allows embedded _ in a number on either side of the #{e}", ->
      expect( R.$Float("2_0#{e}100")).toEqual  R.$Float(20e100)
      expect( R.$Float("20#{e}1_00")).toEqual  R.$Float(20e100)
      expect( R.$Float("2_0#{e}1_00")).toEqual R.$Float(20e100)

    it "raises an exception if a space is embedded on either side of the '#{e}'", ->
      expect( -> R.$Float("2 0#{e}100") ).toThrow "ArgumentError"
      expect( -> R.$Float("20#{e}1 00") ).toThrow "ArgumentError"

    xdescribe 'not worth the hassle', ->
      it "raises an exception if there's a leading _ on either side of the '#{e}'", ->
        expect( -> R.$Float("_20#{e}100") ).toThrow "ArgumentError"
        expect( -> R.$Float("20#{e}_100") ).toThrow "ArgumentError"

      it "raises an exception if there's a trailing _ on either side of the '#{e}'", ->
        expect( -> R.$Float("20_#{e}100") ).toThrow "ArgumentError"
        expect( -> R.$Float("20#{e}100_") ).toThrow "ArgumentError"

    xit "allows decimal points on the left side of the '#{e}'", ->
      expect( R.$Float("2.0#{e}2")).toEqual R.float(200)

#     it "raises an ArgumentError if there's a decimal point on the right side of the '#{e}'", ->
#       expect( -> R.$Float("20#{e}2.0") ).toThrow "ArgumentError"

  it "returns a Float that can be a parameter to #Float again", ->
    float = R.$Float("10")
    expect( R.$Float(float)).toEqual R.$Float(10.0)

  # it "otherwise, converts the given argument to a Float by calling #to_f", ->
  #   (obj = mock('1.2')).should_receive(:to_f).once.and_return(1.2)
  #   obj.should_not_receive(:to_i)
  #   expect( R.$Float(obj)).toEqual 1.2

#   ruby_version_is '' ... '1.8.7' do
#     it "raises an Argument Error if to_f is called and it returns NaN", ->
#       (nan = mock('NaN')).should_receive(:to_f).once.and_return(nan_value)
#       expect( -> R.$Float(nan) ).toThrow "ArgumentError"

#   ruby_version_is '1.8.7' do
#     it "returns the identical NaN if to_f is called and it returns NaN", ->
#       nan = nan_value
#       (nan_to_f = mock('NaN')).should_receive(:to_f).once.and_return(nan)
#       nan2 = R.$Float(nan_to_f)
#       nan2.nan?.should be_true
#       expect( nan2).toEqual(nan)

#   it "returns the identical Infinity if to_f is called and it returns Infinity", ->
#     infinity = infinity_value
#     (infinity_to_f = mock('Infinity')).should_receive(:to_f).once.and_return(infinity)
#     infinity2 = R.$Float(infinity_to_f)
#     expect( infinity2).toEqual(infinity)

  it "raises a TypeError if #to_f is not provided", ->
    expect( -> R.$Float(new Object()) ).toThrow "TypeError"

  xit "raises a TypeError if #to_f returns a String", ->
    # (obj = mock('ha!')).should_receive(:to_f).once.and_return('ha!')
    # expect( -> R.$Float(obj) ).toThrow "TypeError"

  xit "raises a TypeError if #to_f returns an Integer", ->
    # (obj = mock('123')).should_receive(:to_f).once.and_return(123)
    # expect( -> R.$Float(obj) ).toThrow "TypeError"
