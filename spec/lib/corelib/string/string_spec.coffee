describe "String#multiply", ->
  it "multiply", ->
    expect(R("-").multiply(2).unbox()).toEqual("--")

  it "returns a new string containing count copies of self", ->
    expect(R("cool").multiply(0).unbox()).toEqual("")
    expect(R("cool").multiply(1).unbox()).toEqual("cool")
    expect(R("cool").multiply(3).unbox()).toEqual("coolcoolcool")

  it "tries to convert the given argument to an integer using to_int", ->
    expect(R("cool").multiply(3.1).unbox()).toEqual("coolcoolcool")
    expect(R("a").multiply(3.999).unbox() ).toEqual("aaa")

  it "raises an ArgumentError when given integer is negative", ->
    expect(-> R("cool").multiply -3    ).toThrow("ArgumentError")
    expect(-> R("cool").multiply -3.14 ).toThrow("ArgumentError")

#  it "raises a RangeError when given integer is a Bignum", ->
#    lambda { "cool" * 999999999999999999999 }.should raise_error(RangeError)
