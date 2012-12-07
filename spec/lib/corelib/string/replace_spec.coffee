describe "String#replace", ->
  # describe :string_replace, :shared => true do
  it "returns self", ->
    a = R("a")
    expect( a.replace("b") ).toEqual a

  it "replaces the content of self with other", ->
    a = R("some string")
    a.replace("another string")
    expect( a ).toEqual R("another string")

  xit "taints self if other is tainted", ->
    a = R("")
    b = "".taint
    a.replace(b)
    a.tainted?.should == true

  xit "does not untaint self if other is untainted", ->
    a = R("").taint
    b = ""
    a.replace(b)
    a.tainted?.should == true

  xdescribe 'ruby_version_is "1.9"', ->
    xit "untrusts self if other is untrusted", ->
      a = R("")
      b = "".untrust
      a.replace(b)
      a.untrusted?.should == true

    xit "does not trust self if other is trusted", ->
      a = R("").untrust
      b = ""
      a.replace(b)
      a.untrusted?.should == true

    xit "replaces the encoding of self with that of other", ->
      a = R("").encode("UTF-16LE")
      b = R("").encode("UTF-8")
      a.replace(b)
      a.encoding.should == Encoding::UTF_8

  it "tries to convert other to string using to_str", ->
    other =
      to_str: -> R("converted to a string")
    expect( R("hello").replace(other) ).toEqual R("converted to a string")

  xit "tries to convert other to string using to_str", ->
    other =
      to_str: -> "converted to a string"
    expect( R("hello").replace(other) ).toEqual R("converted to a string")

  it "raises a TypeError if other can't be converted to string", ->
    expect( -> R("hello").replace(123)       ).toThrow('TypeError')
    expect( -> R("hello").replace([])        ).toThrow('TypeError')
    expect( -> R("hello").replace({}) ).toThrow('TypeError')

  # ruby_version_is ""..."1.9", ->
  #   it "raises a TypeError on a frozen instance that is modified", ->
  #     a = "hello".freeze
  #     expect( -> a.replace("world") ).toThrow('TypeError')

  #   it "does not raise an exception on a frozen instance when self-replacing", ->
  #     a = "hello".freeze
  #     a.replace(a).should equal(a)

  describe 'ruby_version_is "1.9"', ->
    xit "raises a RuntimeError on a frozen instance that is modified", ->
      a = R("hello".freeze)
      expect( -> a.replace("world") ).toThrow('RuntimeError')

    # see [ruby-core:23666]
    xit "raises a RuntimeError on a frozen instance when self-replacing", ->
      a = R("hello".freeze)
      expect( -> a.replace(a) ).toThrow('RuntimeError')
