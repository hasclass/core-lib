describe "String#rjust with length, padding", ->
  it "returns a new string of specified length with self right justified and padded with padstr", ->
    expect( R("hello").rjust(20, '1234') ).toEqual R("123412341234123hello")

    expect( R("").rjust(1, "abcd")   ).toEqual R("a")
    expect( R("").rjust(2, "abcd")   ).toEqual R("ab")
    expect( R("").rjust(3, "abcd")   ).toEqual R("abc")
    expect( R("").rjust(4, "abcd")   ).toEqual R("abcd")
    expect( R("").rjust(6, "abcd")   ).toEqual R("abcdab")

    expect( R("OK").rjust(3, "abcd") ).toEqual R("aOK")
    expect( R("OK").rjust(4, "abcd") ).toEqual R("abOK")
    expect( R("OK").rjust(6, "abcd") ).toEqual R("abcdOK")
    expect( R("OK").rjust(8, "abcd") ).toEqual R("abcdabOK")

  it "pads with whitespace if no padstr is given", ->
    expect( R("hello").rjust(20) ).toEqual R("               hello")

  it "returns self if it's longer than or as long as the specified length", ->
    expect( R(""     ).rjust(0) ).toEqual R("")
    expect( R(""     ).rjust(-1) ).toEqual R("")
    expect( R("hello").rjust(4) ).toEqual R("hello")
    expect( R("hello").rjust(-1) ).toEqual R("hello")
    expect( R("this" ).rjust(3) ).toEqual R("this")
    expect( R("radiology").rjust(8, '-') ).toEqual R("radiology")

  # it "taints result when self or padstr is tainted", ->
  #   expect( R("x".taint).rjust(4).tainted? ).toEqual true
  #   expect( R("x".taint).rjust(0).tainted? ).toEqual true
  #   expect( R("".taint).rjust(0).tainted? ).toEqual true
  #   expect( R("x".taint).rjust(4, "*").tainted? ).toEqual true
  #   expect( R("x").rjust(4, "*".taint).tainted? ).toEqual true

  # it "tries to convert length to an integer using to_int", ->
  #   expect( R("^").rjust(3.8, "^_") ).toEqual "^_^"

  #   obj = mock('3')
  #   obj.should_receive(:to_int).and_return(3)

  #   expect( R("o").rjust(obj, "o_") ).toEqual "o_o"

  it "raises a TypeError when length can't be converted to an integer", ->
    expect( -> R("hello").rjust("x")      ).toThrow('TypeError')
    expect( -> R("hello").rjust("x", "y") ).toThrow('TypeError')
    expect( -> R("hello").rjust([])       ).toThrow('TypeError')

  # it "tries to convert padstr to a string using to_str", ->
  #   padstr = mock('123')
  #   padstr.should_receive(:to_str).and_return("123")

  #   "hello".rjust(10, padstr).should == "12312hello"

  it "raises a TypeError when padstr can't be converted", ->
    expect( -> R("hello").rjust(20, [])   ).toThrow('TypeError')

  it "raises an ArgumentError when padstr is empty", ->
    expect( -> R("hello").rjust(10, '')   ).toThrow('ArgumentError')

  # it "returns subclass instances when called on subclasses", ->
  #   StringSpecs::MyString.new("").rjust(10).should be_kind_of(StringSpecs::MyString)
  #   StringSpecs::MyString.new("foo").rjust(10).should be_kind_of(StringSpecs::MyString)
  #   StringSpecs::MyString.new("foo").rjust(10, StringSpecs::MyString.new("x")).should be_kind_of(StringSpecs::MyString)

  #   "".rjust(10, StringSpecs::MyString.new("x")).should be_kind_of(String)
  #   "foo".rjust(10, StringSpecs::MyString.new("x")).should be_kind_of(String)

  # it "when padding is tainted and self is untainted returns a tainted string if and only if length is longer than self", ->
  #   "hello".rjust(4, 'X'.taint).tainted?.should be_false
  #   "hello".rjust(5, 'X'.taint).tainted?.should be_false
  #   "hello".rjust(6, 'X'.taint).tainted?.should be_true
