describe "String#+", ->
  it "returns a new string containing the given string concatenated to self", ->
    expect( R("").plus ""                 ).toEqual R("")
    expect( R("").plus "Hello"            ).toEqual R("Hello")
    expect( R("Hello").plus ""            ).toEqual R("Hello")
    expect( R("Ruby !").plus "= Rubinius" ).toEqual R("Ruby != Rubinius")

  it "converts any non-String argument with #to_str", ->
    c =
      to_str: -> R(' + 1 = 2')

    expect( R("1").plus c).toEqual R('1 + 1 = 2')

  it "raises a TypeError when given any object that fails #to_str", ->
    expect( -> R("").plus {} ).toThrow('TypeError')
    expect( -> R("").plus 65 ).toThrow('TypeError')

  it "doesn't return subclass instances", ->
    expect(new StringSpecs.MyString("hello").plus "").toBeInstanceOf(R.String)
    expect(new StringSpecs.MyString("hello").plus "foo").toBeInstanceOf(R.String)
    expect(new StringSpecs.MyString("hello").plus(new StringSpecs.MyString("foo")) ).toBeInstanceOf(R.String)
    expect(new StringSpecs.MyString("hello").plus(new StringSpecs.MyString("")) ).toBeInstanceOf(R.String)
    expect(new StringSpecs.MyString("").plus(new StringSpecs.MyString("")) ).toBeInstanceOf(R.String)
    expect(R("hello").plus(new StringSpecs.MyString("foo")) ).toBeInstanceOf(R.String)
    expect(R("hello").plus(new StringSpecs.MyString("")) ).toBeInstanceOf(R.String)

  # it "taints the result when self or other is tainted", ->
  #   strs = ["", "OK", new StringSpecs.MyString(""), new StringSpecs.MyString("OK")]
  #   strs += strs.map { |s| s.dup.taint }

  #   strs.each do |str|
  #     strs.each do |other|
  #       (str + other).tainted?.should == (str.tainted? | other.tainted?)

  # it_behaves_like :string_concat_encoding, :+
