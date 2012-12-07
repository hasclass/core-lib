# TODO: Add missing String#[]= specs:
#   String#[range] = obj
#   String#[re] = obj
#   String#[re, idx] = obj
#   String#[str] = obj


describe "String#[]= with String", ->
  it "replaces the char at idx with other_str", ->
    a = R("hello")
    a.set(0, "bam")
    expect( a ).toEqual R("bamello")
    a.set(-2, "")
    expect( a ).toEqual R("bamelo")

  # it "taints self if other_str is tainted", ->
  #   a = R("hello")
  #   a.set(0, "").taint
  #   a.tainted?.should == true
  #   a = R("hello")
  #   a.set(0, "x").taint
  #   a.tainted?.should == true

  it "raises an IndexError without changing self if idx is outside of self", ->
    str = R("hello")

    expect( -> str.set 20, "bam"  ).toThrow('IndexError')
    expect( str ).toEqual R("hello")

    expect( -> str.set -20, "bam"  ).toThrow('IndexError')
    expect( str ).toEqual R("hello")

    expect( -> R("").set -1, "bam"  ).toThrow('IndexError')

  # Behaviour verfieid correct by matz in
  # http://redmine.ruby-lang.org/issues/show/1750
  describe 'ruby_version_is "1.9"', ->
    it "allows assignment to the zero'th element of an empty String", ->
      str = R("")
      str.set 0, "bam"
      expect( str ).toEqual R("bam")

  it "raises IndexError if the string index doesn't match a position in the string", ->
    str = R("hello")
    expect( -> str.set 'y', "bam"  ).toThrow('IndexError')
    expect( str ).toEqual R("hello")


  it "calls to_int on index", ->
    str = R("hello")
    str.set 0.5, "hi "
    expect( str ).toEqual R("hi ello")

    obj =
      to_int: -> R(-1)

    str.set obj, "!"
    expect( str ).toEqual R("hi ell!")

  it "calls #to_str to convert other to a String", ->
    other_str =
      to_str: -> R("-test-")

    a = R("abc")
    a.set 1, other_str
    expect( a ).toEqual R("a-test-c")

  it "raises a TypeError if other_str can't be converted to a String", ->
    expect( -> R("test").set 1, []         ).toThrow('TypeError')
    expect( -> R("test").set 1, {}         ).toThrow('TypeError')
    expect( -> R("test").set 1, null       ).toThrow('TypeError')


  # describe 'ruby_version_is "1.9"', ->
    # it "raises a RuntimeError when self is frozen", ->
    #   a = "hello"
    #   a.freeze
    #   expect( -> a[0] = "bam"  ).toThrow('RuntimeError')

  # describe 'ruby_version_is ""..."1.9"', ->
  #   it "raises an IndexError when setting the zero'th element of an empty String", ->
  #     expect( -> ""[0] = "bam"   ).toThrow('IndexError')



# describe "String#[]= matching with a Regexp", ->
#   it "replaces the matched text with the rhs", ->
#     str = "hello"
#     str[/lo/] = "x"
#     expect( str ).toEqual "helx"

#   it "raises IndexError if the regexp index doesn't match a position in the string", ->
#     str = "hello"
#     expect( -> str[/y/] = "bam"  ).toThrow('IndexError')
#     str.should == "hello"

#   describe "with 3 arguments", ->
#     it "uses the 2nd of 3 arguments as which capture should be replaced", ->
#       str = "aaa bbb ccc"
#       str[/a (bbb) c/, 1] = "ddd"
#       str.should == "aaa ddd ccc"

#     it "allows the specified capture to be negative and count from the end", ->
#       str = "abcd"
#       str[/(a)(b)(c)(d)/, -2] = "e"
#       str.should == "abed"

#     it "raises IndexError if the specified capture isn't available", ->
#       str = "aaa bbb ccc"
#       expect( -> str[/a (bbb) c/,  2] = "ddd"  ).toThrow('IndexError')
#       expect( -> str[/a (bbb) c/, -2] = "ddd"  ).toThrow('IndexError')


xdescribe "String#[]= with index, count", ->
  # it "starts at idx and overwrites count characters before inserting the rest of other_str", ->
  #   a = "hello"
  #   a[0, 2] = "xx"
  #   a.should == "xxllo"
  #   a = "hello"
  #   a[0, 2] = "jello"
  #   a.should == "jellollo"

  # it "counts negative idx values from end of the string", ->
  #   a = "hello"
  #   a[-1, 0] = "bob"
  #   a.should == "hellbobo"
  #   a = "hello"
  #   a[-5, 0] = "bob"
  #   a.should == "bobhello"

  # it "overwrites and deletes characters if count is more than the length of other_str", ->
  #   a = "hello"
  #   a[0, 4] = "x"
  #   a.should == "xo"
  #   a = "hello"
  #   a[0, 5] = "x"
  #   a.should == "x"

  # it "deletes characters if other_str is an empty string", ->
  #   a = "hello"
  #   a[0, 2] = ""
  #   a.should == "llo"

  # it "deletes characters up to the maximum length of the existing string", ->
  #   a = "hello"
  #   a[0, 6] = "x"
  #   a.should == "x"
  #   a = "hello"
  #   a[0, 100] = ""
  #   a.should == ""

  # it "appends other_str to the end of the string if idx == the length of the string", ->
  #   a = "hello"
  #   a[5, 0] = "bob"
  #   a.should == "hellobob"

  # it "taints self if other_str is tainted", ->
  #   a = "hello"
  #   a[0, 0] = "".taint
  #   a.tainted?.should == true

  #   a = "hello"
  #   a[1, 4] = "x".taint
  #   a.tainted?.should == true

  # it "raises an IndexError if |idx| is greater than the length of the string", ->
  #   expect( -> "hello"[6, 0] = "bob"   ).toThrow('IndexError')
  #   expect( -> "hello"[-6, 0] = "bob"  ).toThrow('IndexError')

  # it "raises an IndexError if count < 0", ->
  #   expect( -> "hello"[0, -1] = "bob"  ).toThrow('IndexError')
  #   expect( -> "hello"[1, -1] = "bob"  ).toThrow('IndexError')

  # it "raises a TypeError if other_str is a type other than String", ->
  #   expect( -> "hello"[0, 2] = nil   ).toThrow('TypeError')
  #   expect( -> "hello"[0, 2] = []    ).toThrow('TypeError')
  #   expect( -> "hello"[0, 2] = 33    ).toThrow('TypeError')
