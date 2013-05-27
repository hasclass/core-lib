describe "String#count", ->
  xit "counts occurrences of chars from the intersection of the specified sets", ->
    s = R "hello\nworld\x00\x00"

    expect( s.count(s)).toEqual s.size()
    expect( s.count("lo")).toEqual R(5)
    expect( s.count("eo")).toEqual R(3)
    expect( s.count("l")).toEqual R(3)
    expect( s.count("\n")).toEqual R(1)
    expect( s.count("\x00")).toEqual R(2)

    expect( s.count("")).toEqual R(0)
    expect( R("").count("")).toEqual R(0)

    expect( s.count("l", "lo")).toEqual s.count("l")
    expect( s.count("l", "lo", "o")).toEqual s.count("")
    expect( s.count("helo", "hel", "h")).toEqual s.count("h")
    expect( s.count("helo", "", "x")).toEqual R(0)

  xit "raises an ArgumentError when given no arguments", ->
    expect( -> R("hell yeah").count() ).toThrow('ArgumentError')

  xit "negates sets starting with ^", ->
    s = R "^hello\nworld\x00\x00"

    expect( s.count("^leh")).toEqual R(9)
    expect( s.count("^o")).toEqual R(12)

    expect( s.count("helo", "^el")).toEqual s.count("ho")
    expect( s.count("aeiou", "^e")).toEqual s.count("aiou")

    expect( R("^_^").count("^^")).toEqual R(1)
    expect( R("oa^_^o").count("a^")).toEqual R(3)


  xit "counts all chars in a sequence", ->
    s = R "hel-[()]-lo012^"

    expect( s.count("^")).toEqual R(1) # no negation, counts ^
    expect( s.count("^^-^")).toEqual s.size().minus(s.count("^"))

    # TODO: analyze
    # expect( s.count("\x00-\xFF")).toEqual s.size()
    expect( s.count("ej-m")).toEqual R(3)
    expect( s.count("e-h")).toEqual R(2)

    # no sequences
    expect( s.count("-")).toEqual R(2)
    expect( s.count("e-")).toEqual s.count("e").plus(s.count("-"))
    expect( s.count("-h")).toEqual s.count("h").plus(s.count("-"))

    expect( s.count("---")).toEqual s.count("-")

    # see an ASCII table for reference
    expect( s.count("--2")).toEqual s.count("-./012")
    expect( s.count("(--")).toEqual s.count("()*+,-")
    # TODO: analzye
    # expect( s.count("A-a")).toEqual s.count("A-Z[\\]^_`a")

    # negated sequences
    expect( s.count("^e-h")).toEqual s.size().minus(s.count("e-h"))
    expect( s.count("^---")).toEqual s.size().minus(s.count("-"))

    expect( R("abcdefgh").count("a-ce-fh")).toEqual R(6)
    expect( R("abcdefgh").count("he-fa-c")).toEqual R(6)
    expect( R("abcdefgh").count("e-fha-c")).toEqual R(6)

    expect( R("abcde").count("ac-e")).toEqual R(4)
    expect( R("abcde").count("^ac-e")).toEqual R(1)

  # ruby_version_is ""..."1.9", ->
  #   xit "regards invalid sequences as empty", ->
  #     s = R "hel-[()]-lo012^"

  #     # empty sequences (end before start)
  #     s.count("h-e").should == 0
  #     s.count("^h-e").should == s.size

  describe 'ruby_version_is "1.9"', ->
    xit "raises if the given sequences are invalid", ->
      s = R("hel-[()]-lo012^")

      expect( -> s.count("h-e") ).toThrow('ArgumentError')
      expect( -> s.count("^h-e") ).toThrow('ArgumentError')

  xit "calls #to_str to convert each set arg to a String", ->
    other_string =
      to_str: ->
    spy1 = spyOn(other_string, 'to_str').andReturn(R('lo'))

    other_string2 =
      to_str: ->
    spy2 = spyOn(other_string2, 'to_str').andReturn(R('o'))

    s = R("hello world")
    expect( s.count(other_string, other_string2) ).toEqual s.count('o')
    expect( spy1 ).wasCalled()
    expect( spy2 ).wasCalled()


  xit "raises a TypeError when a set arg can't be converted to a string", ->
    expect( -> R("hello world").count(100)       ).toThrow('TypeError')
    expect( -> R("hello world").count([])        ).toThrow('TypeError')
    # expect( -> R("hello world").count(mock('x')) ).toThrow('TypeError')
