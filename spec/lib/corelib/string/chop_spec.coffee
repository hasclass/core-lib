describe "String#chop", ->
  it "returns a new string with the last character removed", ->
    expect( R("hello\n").chop()  ).toEqual R("hello")
    expect( R("hello\x00").chop() ).toEqual R("hello")
    expect( R("hello").chop()     ).toEqual R("hell")

    # ori_str = encode("", "utf-8")
    # 256.times { |i| ori_str << i }
    # str = ori_str
    # 256.times, -> |i|
    #   str = str.chop
    #   str.should == ori_str[0, 255 - i]

  it "removes both characters if the string ends with \\r\\n", ->
    expect( R("hello\r\n").chop() ).toEqual R("hello")
    expect( R("hello\r\n\r\n").chop() ).toEqual R("hello\r\n")
    expect( R("hello\n\r").chop() ).toEqual R("hello\n")
    expect( R("hello\n\n").chop() ).toEqual R("hello\n")
    expect( R("hello\r\r").chop() ).toEqual R("hello\r")

    expect( R("\r\n").chop() ).toEqual R("")

  it "returns an empty string when applied to an empty string", ->
    expect( R("").chop() ).toEqual R("")

  it "returns a new string when applied to an empty string", ->
    s = R("")
    expect( s.chop() != s ).toEqual true

  # xit "taints result when self is tainted", ->
    # "hello".taint).chop() ).toEqualshould == true)
    # "".taint.chop.tainted?.should == true

  # xdescribe 'ruby_version_is "1.9"', ->
  #   xit "untrusts result when self is untrusted", ->
      # "hello".untrust.chop.untrusted?.should == true
      # "".untrust.chop.untrusted?.should == true

  # xit "returns subclass instances when called on a subclass", ->
    # StringSpecs::MyString.new("hello\n").chop.should be_kind_of(StringSpecs::MyString)
    # StringSpecs::MyString.new("hello").chop.should be_kind_of(StringSpecs::MyString)
    # StringSpecs::MyString.new("").chop.should be_kind_of(StringSpecs::MyString)

# describe "String#chop!", ->
#   it "behaves just like chop, but in-place", ->
#     ["hello\n", "hello\r\n", "hello", ""].each, -> |base|
#       str = base.dup
#       str.chop!

#       str.should == base.chop

#   it "returns self if modifications were made", ->
#     ["hello", "hello\r\n"].each, -> |s|
#       s.chop!.should equal(s)

#   it "returns nil when called on an empty string", ->
#     "".chop!.should == nil

#   ruby_version_is ""..."1.9", ->
#     it "raises a TypeError when self is frozen", ->
#       lambda { "string\n\r".freeze.chop! }.should raise_error(TypeError)

#     it "does not raise an exception on a frozen instance that would not be modified", ->
#       "".freeze.chop!.should be_nil

#   ruby_version_is "1.9", ->
#     it "raises a RuntimeError on a frozen instance that is modified", ->
#       lambda { "string\n\r".freeze.chop! }.should raise_error(RuntimeError)

#     # see [ruby-core:23666]
#     it "raises a RuntimeError on a frozen instance that would not be modified", ->
#       a = ""
#       a.freeze
#       lambda { a.chop! }.should raise_error(RuntimeError)
