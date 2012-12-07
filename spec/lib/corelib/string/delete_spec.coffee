describe "String#delete", ->
  it "returns a new string with the chars from the intersection of sets removed", ->
    s = R "hello"
    expect( s.delete("lo") ).toEqual R("he")
    expect( s ).toEqual R("hello")
    expect( R("hello").delete("l", "lo") ).toEqual R("heo")
    expect( R("hell yeah").delete("")    ).toEqual R("hell yeah")

  it "raises an ArgumentError when given no arguments", ->
    expect( -> R("hell yeah").delete() ).toThrow('ArgumentError')

  it "negates sets starting with ^", ->
    expect( R("hello").delete("aeiou", "^e") ).toEqual R("hell")
    expect( R("hello").delete("^leh") ).toEqual R("hell")
    expect( R("hello").delete("^o") ).toEqual R("o")
    expect( R("^_^").delete("^^") ).toEqual R("^^")
    expect( R("oa^_^o").delete("a^") ).toEqual R("o_o")

  xit "TODO", ->
    expect( R("hello").delete("^") ).toEqual R("hello")

  it "deletes all chars in a sequence", ->
    # TODO: analzye
    # expect( R("hello").delete("\x00-\xFF") ).toEqual R("")
    expect( R("hello").delete("ej-m") ).toEqual R("ho")
    expect( R("hello").delete("e-h") ).toEqual R("llo")
    expect( R("hel-lo").delete("e-") ).toEqual R("hllo")
    expect( R("hel-lo").delete("-h") ).toEqual R("ello")
    expect( R("hel-lo").delete("---") ).toEqual R("hello")
    expect( R("hel-012").delete("--2") ).toEqual R("hel")
    expect( R("hel-()").delete("(--") ).toEqual R("hel")
    expect( R("hello").delete("^e-h") ).toEqual R("he")
    expect( R("hello^").delete("^^-^") ).toEqual R("^")
    expect( R("hel--lo").delete("^---") ).toEqual R("--")

    expect( R("abcdefgh").delete("a-ce-fh") ).toEqual R("dg")
    expect( R("abcdefgh").delete("he-fa-c") ).toEqual R("dg")
    expect( R("abcdefgh").delete("e-fha-c") ).toEqual R("dg")

    expect( R("abcde").delete("ac-e") ).toEqual R("b")
    expect( R("abcde").delete("^ac-e") ).toEqual R("acde")

    # TODO: analzye
    # expect( R("ABCabc[]").delete("A-a") ).toEqual R("bc")

  # DIFFERENCE:
  it "respects backslash for escaping a -", ->
    #expect( R('Non-Authoritative Information').delete(" \-\'") ).toEqual R('NonAuthoritativeInformation')
    expect( R('Non-Authoritative Information').delete(" \\-\'") ).toEqual R('NonAuthoritativeInformation')

  # ruby_version_is ""..."1.9", ->
  #   it "regards invalid ranges as nothing", ->
  #     "hello".delete("h-e").should == "hello"
  #     "hello".delete("^h-e").should == ""

  describe 'ruby_version_is "1.9"', ->
    it "raises if the given ranges are invalid", ->
      expect( -> R("hello").delete("h-e") ).toThrow('ArgumentError')
      expect( -> R("hello").delete("^h-e") ).toThrow('ArgumentError')

  # it "taints result when self is tainted", ->
  #   "hello".taint.delete("e").tainted?.should == true
  #   "hello".taint.delete("a-z").tainted?.should == true

  #   "hello".delete("e".taint).tainted?.should == false

  it "tries to convert each set arg to a string using to_str", ->
    other_string =
      to_str: ->
    spy1 = spyOn(other_string, 'to_str').andReturn(R('lo'))

    other_string2 =
      to_str: ->
    spy2 = spyOn(other_string2, 'to_str').andReturn(R('o'))

    expect( R("hello world").delete(other_string, other_string2) ).toEqual R("hell wrld")
    expect( spy1 ).wasCalled()
    expect( spy2 ).wasCalled()

  it "raises a TypeError when one set arg can't be converted to a string", ->
    expect( -> R("hello world").delete(100)       ).toThrow('TypeError')
    expect( -> R("hello world").delete([])        ).toThrow('TypeError')
    # expect( -> R("hello world").delete(mock('x')) ).toThrow('TypeError')

  # xit "returns subclass instances when called on a subclass", ->
  #   # StringSpecs::MyString.new("oh no!!!").delete("!").should be_kind_of(StringSpecs::MyString)

describe "String#delete!", ->
  it "modifies self in place and returns self", ->
    a = R "hello"
    expect( a.delete_bang("aeiou", "^e") is a).toEqual true
    expect( a ).toEqual R("hell")

  it "returns nil if no modifications were made", ->
    a = R "hello"
    expect( a.delete_bang("z") is null).toEqual true
    expect( a ).toEqual R("hello")

  # ruby_version_is ""..."1.9", ->
  #   it "raises a TypeError when self is frozen", ->
  #     a = R "hello"
  #     a.freeze

  #     lambda { a.delete_bang("")            }.should raise_error(TypeError)
  #     lambda { a.delete_bang("aeiou", "^e") }.should raise_error(TypeError)

  # ruby_version_is "1.9", ->
  #   it "raises a RuntimeError when self is frozen", ->
  #     a = R "hello"
  #     a.freeze

  #     lambda { a.delete_bang("")            }.should raise_error(RuntimeError)
  #     lambda { a.delete_bang("aeiou", "^e") }.should raise_error(RuntimeError)
