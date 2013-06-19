describe "String#sub with pattern, replacement", ->
  it "returns a copy of self with all occurrences of pattern replaced with replacement", ->
    expect( R("hello").sub(/[aeiou]/, '*') ).toEqual R("h*llo")
    expect( R("hello").sub(//, ".") ).toEqual R(".hello")

  it "ignores a block if supplied", ->
    expect( R("food").sub(/f/, "g", -> "w") ).toEqual R("good")

  xit "supports \\G which matches at the beginning of the string", ->
    # expect( R("hello world!").sub(/\Ghello/, "hi") ).toEqual R("hi world!")

  it "supports /i for ignoring case", ->
    expect( R("Hello").sub(/h/i, "j") ).toEqual R("jello")
    expect( R("hello").sub(/H/i, "j") ).toEqual R("jello")

  it "doesn't interpret regexp metacharacters if pattern is a string", ->
    expect( R("12345").sub('\d', 'a') ).toEqual R("12345")
    expect( R('\d').sub('\d', 'a') ).toEqual R("a")

  it "replaces \\1 sequences with the regexp's corresponding capture", ->
    str = R("hello")

    expect( str.sub(/([aeiou])/, '<$1>') ).toEqual R("h<e>llo")
    expect( str.sub(/(.)/, '$1$1') ).toEqual R("hhello")

    # expect( str.sub(/.(.?)/, '<\0>(\1)') ).toEqual R("<he>(e)llo")

    expect( str.sub(/.(.)+/, '$1') ).toEqual R("o")

    str = R("ABCDEFGHIJKL")
    re = /#{"(.)" * 12}/
    re = /(.)(.)(.)(.)(.)(.)(.)(.)(.)(.)(.)(.)/
    expect( str.sub(re, '$1') ).toEqual R("A")
    expect( str.sub(re, '$9') ).toEqual R("I")

    # DOCUMENT difference:
    # Only the first 9 captures can be accessed in MRI
    # expect( str.sub(re, '$10') ).toEqual R("A0")

  # DOCUMENT: difference
  xit "treats \\1 sequences without corresponding captures as empty strings", ->
    str = R("hello!")
    expect( str.sub("", '<$1>') ).toEqual R("<>hello!")
    expect( str.sub("h", '<$1>') ).toEqual R("<>ello!")

    expect( str.sub(//, '<$1>') ).toEqual R("<>hello!")
    expect( str.sub(/./, '$1$2$3') ).toEqual R("ello!")
    expect( str.sub(/.(.{20})?/, '$1') ).toEqual R("ello!")

  # DOCUMENT: difference
  it "replaces \\& and \\0 with the complete match", ->
    # str = R("hello!")

    # expect( str.sub("", '<\0>') ).toEqual R("<>hello!")
    # expect( str.sub("", '<\&>') ).toEqual R("<>hello!")
    # expect( str.sub("he", '<\0>') ).toEqual R("<he>llo!")
    # expect( str.sub("he", '<\&>') ).toEqual R("<he>llo!")
    # expect( str.sub("l", '<\0>') ).toEqual R("he<l>lo!")
    # expect( str.sub("l", '<\&>') ).toEqual R("he<l>lo!")

    # expect( str.sub(//, '<\0>') ).toEqual R("<>hello!")
    # expect( str.sub(//, '<\&>') ).toEqual R("<>hello!")
    # expect( str.sub(/../, '<\0>') ).toEqual R("<he>llo!")
    # expect( str.sub(/../, '<\&>') ).toEqual R("<he>llo!")
    # expect( str.sub(/(.)./, '<\0>') ).toEqual R("<he>llo!")

  it "replaces \\` with everything before the current match", ->
    str = R("hello!")

    expect( str.sub("", '<$`>') ).toEqual R("<>hello!")
    expect( str.sub("h", '<$`>') ).toEqual R("<>ello!")
    expect( str.sub("l", '<$`>') ).toEqual R("he<he>lo!")
    expect( str.sub("!", '<$`>') ).toEqual R("hello<hello>")

    expect( str.sub(//, '<$`>') ).toEqual R("<>hello!")
    expect( str.sub(/..o/, '<$`>') ).toEqual R("he<he>!")

  it "replaces \\' with everything after the current match", ->
    str = R("hello!")

    expect( str.sub("", '<$\'>') ).toEqual R("<hello!>hello!")
    expect( str.sub("h", '<$\'>') ).toEqual R("<ello!>ello!")
    expect( str.sub("ll", '<$\'>') ).toEqual R("he<o!>o!")
    expect( str.sub("!", '<$\'>') ).toEqual R("hello<>")

    expect( str.sub(//, '<$\'>') ).toEqual R("<hello!>hello!")
    expect( str.sub(/../, '<$\'>') ).toEqual R("<llo!>llo!")

#   it "replaces \\\\\\+ with \\\\+", ->
#     expect( "x".sub(/x/, '\\\+') ).toEqual R("\\+")

  # DOCUMENT: difference
  xit "replaces \\+ with the last paren that actually matched", ->
    # str = R("hello!")

    # expect( str.sub(/(.)(.)/, '\+') ).toEqual R("ello!")
    # expect( str.sub(/(.)(.)+/, '\+') ).toEqual R("!")
    # expect( str.sub(/(.)()/, '\+') ).toEqual R("ello!")
    # expect( str.sub(/(.)(.{20})?/, '<\+>') ).toEqual R("<h>ello!")

    # str = R("ABCDEFGHIJKL")
    # re = /#{"(.)" * 12}/
    # expect( str.sub(re, '\+') ).toEqual R("L")

  # DOCUMENT: difference
  xit "treats \\+ as an empty string if there was no captures", ->
    expect( R("hello!").sub(/./, '$+') ).toEqual R("ello!")

  it "maps \\\\ in replacement to \\", ->
    expect( R("hello").sub(/./, '$$') ).toEqual R('$ello')

  it "leaves unknown \\x escapes in replacement untouched", ->
    expect( R("hello").sub(/./, '\\x') ).toEqual R('\\xello')
    expect( R("hello").sub(/./, '\\y') ).toEqual R('\\yello')

  it "leaves \\ at the end of replacement untouched", ->
    expect( R("hello").sub(/./, 'hah\\') ).toEqual R('hah\\ello')

  it "tries to convert pattern to a string using valueOf", ->
    pattern =
      valueOf: -> "."

    expect( R("hello.").sub(pattern, "!") ).toEqual R("hello!")

  it "raises a TypeError when pattern can't be converted to a string", ->
    expect( -> R("hello").sub({}, "x")           ).toThrow('TypeError')
    expect( -> R("hello").sub([], "x")           ).toThrow('TypeError')
    expect( -> R("hello").sub(new Object(), null)).toThrow('TypeError')
    expect( R("hello").sub(new String('e'), 'x') ).toEqual R("hxllo")

  it "tries to convert replacement to a string using valueOf", ->
    replacement =
      valueOf: -> "hello_replacement"

    expect( R("hello").sub(/hello/, replacement) ).toEqual R("hello_replacement")

  it "raises a TypeError when replacement can't be converted to a string", ->
    expect( -> R("hello").sub(/[aeiou]/, []) ).toThrow('TypeError')
    expect( -> R("hello").sub(/[aeiou]/, 99) ).toThrow('TypeError')

  it "returns subclass instances when called on a subclass", ->
    expect( new StringSpecs.MyString("").sub(//, "")       ).toBeInstanceOf(StringSpecs.MyString)
    expect( new StringSpecs.MyString("").sub(/foo/, "")    ).toBeInstanceOf(StringSpecs.MyString)
    expect( new StringSpecs.MyString("foo").sub(/foo/, "") ).toBeInstanceOf(StringSpecs.MyString)
    expect( new StringSpecs.MyString("foo").sub("foo", "") ).toBeInstanceOf(StringSpecs.MyString)

  # DOCUMENT HERE
  xit "sets $~ to MatchData of match and nil when there's none", ->
    R('hello.').sub('hello', 'x')
    expect( R['$~'][0] ).toEqual R('hello')

    R('hello.').sub('not', 'x')
    expect( R['$~'] ).toEqual null

    R('hello.').sub(/.(.)/, 'x')
    expect( R['$~'][0] ).toEqual R('he')

    R('hello.').sub(/not/, 'x')
    expect( R['$~'] ).toEqual null

  # DOCUMENT HERE
  # xit "replaces \\\1 with \1", ->
    # expect( R("ababa").sub(/(b)/, '\\\1') ).toEqual R("a\\1aba")

  # xit "replaces \\\\1 with \\1", ->
    # expect( R("ababa").sub(/(b)/, '\\\\1') ).toEqual R("a\\1aba")

  # xit "replaces \\\\\1 with \\", ->
    # expect( R("ababa").sub(/(b)/, '\\\\\1') ).toEqual R("a\\baba")

  # it "taints the result if the original string or replacement is tainted", ->
  #   hello = "hello"
  #   hello_t = "hello"
  #   a = "a"
  #   a_t = "a"
  #   empty = ""
  #   empty_t = ""

  #   hello_t.taint; a_t.taint; empty_t.taint

  #   hello_t.sub(/./, a).tainted?.should == true
  #   hello_t.sub(/./, empty).tainted?.should == true

  #   hello.sub(/./, a_t).tainted?.should == true
  #   hello.sub(/./, empty_t).tainted?.should == true
  #   hello.sub(//, empty_t).tainted?.should == true

  #   hello.sub(//.taint, "foo").tainted?.should == false

describe "String#sub with pattern and block", ->
  it "returns a copy of self with the first occurrences of pattern replaced with the block's return value", ->
    # expect( R("hi").sub(/./, (s) -> s + ' ' ) ).toEqual R("h i")
    # expect( R("hi!").sub(/(.)(.)/) { |*a| a.inspect }.should == '["hi"]!'

#   it "sets $~ for access from the block", ->
#     str = "hello"
#     expect( str.sub(/([aeiou])/) { "<#{$~[1]}>" } ).toEqual R("h<e>llo")
#     expect( str.sub(/([aeiou])/) { "<#{$1}>" } ).toEqual R("h<e>llo")
#     expect( str.sub("l") { "<#{$~[0]}>" } ).toEqual R("he<l>lo")

#     offsets = []

#     str.sub(/([aeiou])/) do
#        md = $~
#        md.string.should == str
#        offsets << md.offset(0)
#        str
#     end.should == "hhellollo"

#     offsets.should == [[1, 2]]

#   # The conclusion of bug #1749 was that this example was version-specific...
#   ruby_version_is "".."1.9", ->
#     it "restores $~ after leaving the block", ->
#       [/./, "l"].each do |pattern|
#         old_md = nil
#         "hello".sub(pattern) do
#           old_md = $~
#           "ok".match(/./)
#           "x"

#         $~.should == old_md
#         $~.string.should == "hello"

#   it "sets $~ to MatchData of last match and nil when there's none for access from outside", ->
#     'hello.'.sub('l') { 'x' }
#     $~.begin(0).should == 2
#     $~[0].should == 'l'

#     'hello.'.sub('not') { 'x' }
#     $~.should == nil

#     'hello.'.sub(/.(.)/) { 'x' }
#     $~[0].should == 'he'

#     'hello.'.sub(/not/) { 'x' }
#     $~.should == nil

#   it "doesn't raise a RuntimeError if the string is modified while substituting", ->
#     str = "hello"
#     str.sub(//) { str[0] = 'x' }.should == "xhello"
#     str.should == "xello"

#   it "doesn't interpolate special sequences like \\1 for the block's return value", ->
#     repl = '\& \0 \1 \` \\\' \+ \\\\ foo'
#     "hello".sub(/(.+)/) { repl }.should == repl

#   it "converts the block's return value to a string using to_s", ->
#     obj = mock('hello_replacement')
#     obj.should_receive(:to_s).and_return("hello_replacement")
#     "hello".sub(/hello/) { obj }.should == "hello_replacement"

#     obj = mock('ok')
#     obj.should_receive(:to_s).and_return("ok")
#     "hello".sub(/.+/) { obj }.should == "ok"

#   it "taints the result if the original string or replacement is tainted", ->
#     hello = "hello"
#     hello_t = "hello"
#     a = "a"
#     a_t = "a"
#     empty = ""
#     empty_t = ""

#     hello_t.taint; a_t.taint; empty_t.taint

#     hello_t.sub(/./) { a }.tainted?.should == true
#     hello_t.sub(/./) { empty }.tainted?.should == true

#     hello.sub(/./) { a_t }.tainted?.should == true
#     hello.sub(/./) { empty_t }.tainted?.should == true
#     hello.sub(//) { empty_t }.tainted?.should == true

#     hello.sub(//.taint) { "foo" }.tainted?.should == false
# end

# describe "String#sub! with pattern, replacement", ->
#   it "modifies self in place and returns self", ->
#     a = "hello"
#     a.sub!(/[aeiou]/, '*').should equal(a)
#     a.should == "h*llo"

#   it "taints self if replacement is tainted", ->
#     a = "hello"
#     a.sub!(/./.taint, "foo").tainted?.should == false
#     a.sub!(/./, "foo".taint).tainted?.should == true

#   it "returns nil if no modifications were made", ->
#     a = "hello"
#     a.sub!(/z/, '*').should == nil
#     a.sub!(/z/, 'z').should == nil
#     a.should == "hello"

#   ruby_version_is ""..."1.9", ->
#     it "raises a TypeError when self is frozen", ->
#       s = "hello"
#       s.freeze

#       s.sub!(/ROAR/, "x") # ok
#       lambda { s.sub!(/e/, "e")       }.should raise_error(TypeError)
#       lambda { s.sub!(/[aeiou]/, '*') }.should raise_error(TypeError)

#   ruby_version_is "1.9", ->
#     it "raises a RuntimeError when self is frozen", ->
#       s = "hello"
#       s.freeze

#       lambda { s.sub!(/ROAR/, "x")    }.should raise_error(RuntimeError)
#       lambda { s.sub!(/e/, "e")       }.should raise_error(RuntimeError)
#       lambda { s.sub!(/[aeiou]/, '*') }.should raise_error(RuntimeError)
#   end

# describe "String#sub! with pattern and block", ->
#   it "modifies self in place and returns self", ->
#     a = "hello"
#     a.sub!(/[aeiou]/) { '*' }.should equal(a)
#     a.should == "h*llo"

#   it "sets $~ for access from the block", ->
#     str = "hello"
#     str.dup.sub!(/([aeiou])/) { "<#{$~[1]}>" }.should == "h<e>llo"
#     str.dup.sub!(/([aeiou])/) { "<#{$1}>" }.should == "h<e>llo"
#     str.dup.sub!("l") { "<#{$~[0]}>" }.should == "he<l>lo"

#     offsets = []

#     str.dup.sub!(/([aeiou])/) do
#        md = $~
#        md.string.should == str
#        offsets << md.offset(0)
#        str
#     end.should == "hhellollo"

#     offsets.should == [[1, 2]]

  # it "taints self if block's result is tainted", ->
  #   a = "hello"
  #   a.sub!(/./.taint) { "foo" }.tainted?.should == false
  #   a.sub!(/./) { "foo".taint }.tainted?.should == true

  # it "returns nil if no modifications were made", ->
  #   a = "hello"
  #   a.sub!(/z/) { '*' }.should == nil
  #   a.sub!(/z/) { 'z' }.should == nil
  #   a.should == "hello"

  # not_compliant_on :rubinius do
  #   it "raises a RuntimeError if the string is modified while substituting", ->
  #     str = "hello"
  #     lambda { str.sub!(//) { str << 'x' } }.should raise_error(RuntimeError)
  # ruby_version_is ""..."1.9", ->
  #   deviates_on :rubinius do
  #     # MRI 1.8.x is inconsistent here, raising a TypeError when not passed
  #     # a block and a RuntimeError when passed a block. This is arguably a
  #     # bug in MRI. In 1.9, both situations raise a RuntimeError.
  #     it "raises a TypeError when self is frozen", ->
  #       s = "hello"
  #       s.freeze
  #
  #       s.sub!(/ROAR/) { "x" } # ok
  #       lambda { s.sub!(/e/) { "e" }       }.should raise_error(TypeError)
  #       lambda { s.sub!(/[aeiou]/) { '*' } }.should raise_error(TypeError)
  #
  #   not_compliant_on :rubinius do
  #     it "raises a RuntimeError when self is frozen", ->
  #       s = "hello"
  #       s.freeze
  #
  #       s.sub!(/ROAR/) { "x" } # ok
  #       lambda { s.sub!(/e/) { "e" }       }.should raise_error(RuntimeError)
  #       lambda { s.sub!(/[aeiou]/) { '*' } }.should raise_error(RuntimeError)
  #
  # ruby_version_is "1.9", ->
  #   it "raises a RuntimeError when self is frozen", ->
  #     s = "hello"
  #     s.freeze
  #
  #     lambda { s.sub!(/ROAR/) { "x" }    }.should raise_error(RuntimeError)
  #     lambda { s.sub!(/e/) { "e" }       }.should raise_error(RuntimeError)
  #     lambda { s.sub!(/[aeiou]/) { '*' } }.should raise_error(RuntimeError)
