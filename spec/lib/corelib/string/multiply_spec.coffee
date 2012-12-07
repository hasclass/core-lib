describe "String#*", ->
  it "returns a new string containing count copies of self", ->
    expect( R("cool").multiply 0).toEqual R("")
    expect( R("cool").multiply 1).toEqual R("cool")
    expect( R("cool").multiply 3).toEqual R("coolcoolcool")

  it "tries to convert the given argument to an integer using to_int", ->
    expect( R("cool").multiply 3.1).toEqual R("coolcoolcool")
    expect( R("a").multiply  3.999).toEqual R("aaa")
    a =
      to_int: -> R(4)
    expect( R("a").multiply a).toEqual R("aaaa")

  it "raises an ArgumentError when given integer is negative", ->
    expect( -> R("cool").multiply -3    ).toThrow('ArgumentError')
    expect( -> R("cool").multiply -3.14 ).toThrow('ArgumentError')

  xit "raises a RangeError when given integer is a Bignum", ->
    # lambda { "cool" * 999999999999999999999 }.should raise_error(RangeError)

  xit "returns subclass instances", ->
    # (StringSpecs::MyString.new("cool") * 0).should be_kind_of(StringSpecs::MyString)
    # (StringSpecs::MyString.new("cool") * 1).should be_kind_of(StringSpecs::MyString)
    # (StringSpecs::MyString.new("cool") * 2).should be_kind_of(StringSpecs::MyString)

  xit "always taints the result when self is tainted", ->
    # ["", "OK", StringSpecs::MyString.new(""), StringSpecs::MyString.new("OK")].each do |str|
    #   str.taint
    #   [0, 1, 2].each do |arg|
    #     (str * arg).tainted?.should == true
