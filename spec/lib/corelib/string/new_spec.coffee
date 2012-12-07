describe "String.new", ->
  it "returns an instance of String", ->
    str = R.String.new()
    expect( str ).toBeInstanceOf(R.String)

  it "returns a fully-formed String", ->
    str = R.String.new()
    expect( str.size() ).toEqual R(0)
    str.append "more"
    expect( str.to_native() ).toEqual "more"

  it "returns a new string given a string argument", ->
    str1 = "test"
    str = R.String.new(str1)
    expect( str ).toBeInstanceOf(R.String)
    expect( str ).toEqual str
    str.append "more"
    expect( str ).toEqual R("testmore")

  xit "returns an instance of a subclass", ->
    a = StringSpecs.MyString.new("blah")
    expect( a ).toBeInstanceOf(StringSpecs.MyString)
    expect( a.to_native() ).toEqual "blah"

  xit "is called on subclasses", ->
    s = StringSpecs.SubString.new()
    expect( s.special ).toEqual null
    expect( s.to_native() ).toEqual ""

    s = StringSpecs.SubString.new "subclass"
    expect( s.special ).toEqual R("subclass")
    expect( s.to_native() ).toEqual ""

  xit "raises TypeError on inconvertible object", ->
    expect( -> R.String.new 5    ).toThrow('TypeError')
    expect( -> R.String.new null ).toThrow('TypeError')

  # ruby_version_is "1.9", ->
  #   it "returns a binary String", ->
  #     String.new.encoding.should == Encoding::BINARY

