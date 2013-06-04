describe "String#multiply", ->
  it "multiply", ->
    expect(R("-").multiply(2).valueOf()).toEqual("--")

  it "returns a new string containing count copies of self", ->
    expect(R("cool").multiply(0).valueOf()).toEqual("")
    expect(R("cool").multiply(1).valueOf()).toEqual("cool")
    expect(R("cool").multiply(3).valueOf()).toEqual("coolcoolcool")

  it "tries to convert the given argument to an integer using to_int", ->
    expect(R("cool").multiply(3.1).valueOf()).toEqual("coolcoolcool")
    expect(R("a").multiply(3.999).valueOf() ).toEqual("aaa")

  it "raises an ArgumentError when given integer is negative", ->
    expect(-> R("cool").multiply -3    ).toThrow("ArgumentError")
    expect(-> R("cool").multiply -3.14 ).toThrow("ArgumentError")

#  it "raises a RangeError when given integer is a Bignum", ->
#    lambda { "cool" * 999999999999999999999 }.should raise_error(RangeError)
