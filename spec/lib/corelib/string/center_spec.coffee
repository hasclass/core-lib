describe "String#center with length, padding", ->
  it "returns a new string of specified length with self centered and padded with padstr", ->
    expect( R("one"   ).center( 9, '.'  ) ).toEqual R("...one...")
    expect( R("hello" ).center(20, '123') ).toEqual R("1231231hello12312312")
    expect( R("middle").center(13, '-'  ) ).toEqual R("---middle----")

    expect( R("").center(1, "abcd") ).toEqual  R("a")
    expect( R("").center(2, "abcd") ).toEqual  R("aa")
    expect( R("").center(3, "abcd") ).toEqual  R("aab")
    expect( R("").center(4, "abcd") ).toEqual  R("abab")
    expect( R("").center(6, "xy"  ) ).toEqual  R("xyxxyx")
    expect( R("").center(11, "12345") ).toEqual  R("12345123451")

    expect( R("|").center(2, "abcd") ).toEqual  R("|a")
    expect( R("|").center(3, "abcd") ).toEqual  R("a|a")
    expect( R("|").center(4, "abcd") ).toEqual  R("a|ab")
    expect( R("|").center(5, "abcd") ).toEqual  R("ab|ab")
    expect( R("|").center(6, "xy") ).toEqual  R("xy|xyx")
    expect( R("|").center(7, "xy") ).toEqual  R("xyx|xyx")
    expect( R("|").center(11, "12345") ).toEqual  R("12345|12345")
    expect( R("|").center(12, "12345") ).toEqual  R("12345|123451")

    expect( R("||").center(3, "abcd") ).toEqual  R("||a")
    expect( R("||").center(4, "abcd") ).toEqual  R("a||a")
    expect( R("||").center(5, "abcd") ).toEqual  R("a||ab")
    expect( R("||").center(6, "abcd") ).toEqual  R("ab||ab")
    expect( R("||").center(8, "xy") ).toEqual  R("xyx||xyx")
    expect( R("||").center(12, "12345") ).toEqual  R("12345||12345")
    expect( R("||").center(13, "12345") ).toEqual  R("12345||123451")

  it "pads with whitespace if no padstr is given", ->
    expect( R("two").center(5) ).toEqual  R(" two ")
    expect( R("hello").center(20) ).toEqual  R("       hello        ")

  it "returns self if it's longer than or as long as the specified length", ->
    expect( R("").center(0) ).toEqual  R("")
    expect( R("").center(-1) ).toEqual  R("")
    expect( R("hello").center(4) ).toEqual  R("hello")
    expect( R("hello").center(-1) ).toEqual  R("hello")
    expect( R("this").center(3) ).toEqual  R("this")
    expect( R("radiology").center(8, '-') ).toEqual  R("radiology")

  xit "taints result when self or padstr is tainted", ->
    # "x".taint.center(4).tainted?.should == true
    # "x".taint.center(0).tainted?.should == true
    # "".taint.center(0).tainted?.should == true
    # "x".taint.center(4, "*").tainted?.should == true
    # "x".center(4, "*".taint).tainted?.should == true

  # it "calls #to_int to convert length to an integer", ->
  #   "_".center(3.8, "^").should == "^_^"

  #   obj = mock('3')
  #   obj.should_receive(:to_int).and_return(3)

  #   "_".center(obj, "o").should == "o_o"

  it "raises a TypeError when length can't be converted to an integer", ->
    expect( -> R("hello").center("x")       ).toThrow('TypeError')
    expect( -> R("hello").center("x", "y")  ).toThrow('TypeError')
    expect( -> R("hello").center([])        ).toThrow('TypeError')
    # expect( -> R("hello").center(mock('x')) ).toThrow('TypeError')

  it "calls #to_str to convert padstr to a String", ->
    padstr =
      to_str: -> R("123")

    expect( R("hello").center(20, padstr) ).toEqual R("1231231hello12312312")

  it "raises a TypeError when padstr can't be converted to a string", ->
    expect( -> R("hello").center(20, 100)        ).toThrow('TypeError')
    expect( -> R("hello").center(20, [])       ).toThrow('TypeError')
    # expect( -> R("hello").center(20, mock('x'))  ).toThrow('TypeError')

  it "raises an ArgumentError if padstr is empty", ->
    expect( -> R("hello").center(10, "") ).toThrow('ArgumentError')
    expect( -> R("hello").center(0, "")  ).toThrow('ArgumentError')

  # it "returns subclass instances when called on subclasses", ->
  #   StringSpecs::MyString.new("").center(10).should be_kind_of(StringSpecs::MyString)
  #   StringSpecs::MyString.new("foo").center(10).should be_kind_of(StringSpecs::MyString)
  #   StringSpecs::MyString.new("foo").center(10, StringSpecs::MyString.new("x")).should be_kind_of(StringSpecs::MyString)

  #   "".center(10, StringSpecs::MyString.new("x")).should be_kind_of(String)
  #   "foo".center(10, StringSpecs::MyString.new("x")).should be_kind_of(String)

  # it "when padding is tainted and self is untainted returns a tainted string if and only if length is longer than self", ->
  #   "hello".center(4, 'X'.taint).tainted?.should be_false
  #   "hello".center(5, 'X'.taint).tainted?.should be_false
  #   "hello".center(6, 'X'.taint).tainted?.should be_true
