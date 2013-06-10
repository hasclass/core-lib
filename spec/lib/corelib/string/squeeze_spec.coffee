describe "String#squeeze", ->
  it "returns new string where runs of the same character are replaced by a single character when no args are given", ->
    expect( R("yellow moon").squeeze() ).toEqual R("yelow mon")

  it "only squeezes chars that are in the intersection of all sets given", ->
    expect( R("woot squeeze cheese").squeeze("eost", "queo") ).toEqual R("wot squeze chese")
    expect( R("  now   is  the").squeeze(" ") ).toEqual R(" now is the")

  it "negates sets starting with ^", ->
    s = "<<subbookkeeper!!!>>"
    expect( R(s).squeeze("beko", "^e")    ).toEqual R(s).squeeze("bko")
    expect( R(s).squeeze("^<bek!>")       ).toEqual R(s).squeeze("o")
    expect( R(s).squeeze("^o")            ).toEqual R(s).squeeze("<bek!>")
    expect( R(s).squeeze("^")             ).toEqual R(s)
    expect( R("^__^").squeeze("^^")       ).toEqual R("^_^")
    expect( R("((^^__^^))").squeeze("_^") ).toEqual R("((^_^))")

  it "squeezes all chars in a sequence", ->
    s = "--subbookkeeper--"
    # TODO: analyse
    # expect( R(s).squeeze("\x00-\xFF") ).toEqual R(s).squeeze()
    expect( R(s).squeeze("bk-o") ).toEqual R(s).squeeze("bklmno")
    expect( R(s).squeeze("b-e") ).toEqual R(s).squeeze("bcde")
    expect( R(s).squeeze("e-") ).toEqual R("-subbookkeper-")
    expect( R(s).squeeze("-e") ).toEqual R("-subbookkeper-")
    expect( R(s).squeeze("---") ).toEqual R("-subbookkeeper-")
    expect( R("ook--001122").squeeze("--2") ).toEqual R("ook-012")
    expect( R("ook--(())").squeeze("(--") ).toEqual R("ook-()")
    expect( R(s).squeeze("^b-e") ).toEqual R("-subbokeeper-")
    expect( R("^^__^^").squeeze("^^-^") ).toEqual R("^^_^^")
    expect( R("^^--^^").squeeze("^---") ).toEqual R("^--^")

    expect( R(s).squeeze("b-dk-o-") ).toEqual R("-subokeeper-")
    expect( R(s).squeeze("-b-dk-o") ).toEqual R("-subokeeper-")
    expect( R(s).squeeze("b-d-k-o") ).toEqual R("-subokeeper-")

    expect( R(s).squeeze("bc-e") ).toEqual R("--subookkeper--")
    expect( R(s).squeeze("^bc-e") ).toEqual R("-subbokeeper-")

    # TODO: analyse
    # expect( R("AABBCCaabbcc[[]]").squeeze("A-a") ).toEqual R("ABCabbcc[]")

  # describe 'ruby_version_is "1.8" ... "1.9"', ->
  #   it "doesn't change chars when the parameter is out of sequence", ->
  #     s = "--subbookkeeper--"
  #     expect( R(s).squeeze("e-b") ).toEqual R(s)
  #     expect( R(s).squeeze("^e-b") ).toEqual R(s).squeeze()

  describe 'ruby_version_is "1.9"', ->
    it "raises an ArgumentError when the parameter is out of sequence", ->
      s = "--subbookkeeper--"
      expect( -> R(s).squeeze("e-b")  ).toThrow('ArgumentError')
      expect( -> R(s).squeeze("^e-b") ).toThrow('ArgumentError')

  xit "taints the result when self is tainted", ->
    # "hello".taint.squeeze("e").tainted?.should == true
    # "hello".taint.squeeze("a-z").tainted?.should == true

    # "hello".squeeze("e".taint).tainted?.should == false
    # "hello".squeeze("l".taint).tainted?.should == false

  it "tries to convert each set arg to a string using valueOf", ->
    other_string =
      valueOf: -> "lo"

    other_string2 =
      valueOf: -> "o"

    expect( R("hello room").squeeze(other_string, other_string2) ).toEqual R("hello rom")

  it "raises a TypeError when one set arg can't be converted to a string", ->
    expect( -> R("hello world").squeeze([])         ).toThrow('TypeError')
    expect( -> R("hello world").squeeze(Object.new) ).toThrow('TypeError')
    expect( -> R("hello world").squeeze({})  ).toThrow('TypeError')

  it "returns subclass instances when called on a subclass", ->
    # StringSpecs::MyString.new("oh no!!!").squeeze("!").should be_kind_of(StringSpecs::MyString)

# describe "String#squeeze!", ->
#   it "modifies self in place and returns self", ->
#     a = "yellow moon"
#     a.squeeze!.should equal(a)
#     a.should == "yelow mon"

#   it "returns nil if no modifications were made", ->
#     a = "squeeze"
#     a.squeeze!("u", "sq").should == nil
#     a.squeeze!("q").should == nil
#     a.should == "squeeze"

#   describe 'ruby_version_is "1.8" ... "1.9"', ->
#     it "returns nil when the parameter is out of sequence", ->
#       s = "--subbookkeeper--"
#       s.squeeze!("e-b").should == nil

#     it "removes runs of the same character when the negated sequence is out of order", ->
#       s = "--subbookkeeper--"
#       s.squeeze!("^e-b").should == "-subokeper-"

#   describe 'ruby_version_is "1.9"', ->
#     it "raises an ArgumentError when the parameter is out of sequence", ->
#       s = "--subbookkeeper--"
#       lambda { s.squeeze!("e-b") }.should raise_error(ArgumentError)
#       lambda { s.squeeze!("^e-b") }.should raise_error(ArgumentError)

#   describe 'ruby_version_is ""..."1.9"', ->
#     it "raises a TypeError when self is frozen", ->
#       a = "yellow moon"
#       a.freeze

#       lambda { a.squeeze!("") }.should raise_error(TypeError)
#       lambda { a.squeeze!     }.should raise_error(TypeError)

#   describe 'ruby_version_is "1.9"', ->
#     it "raises a RuntimeError when self is frozen", ->
#       a = "yellow moon"
#       a.freeze

#       lambda { a.squeeze!("") }.should raise_error(RuntimeError)
#       lambda { a.squeeze!     }.should raise_error(RuntimeError)
