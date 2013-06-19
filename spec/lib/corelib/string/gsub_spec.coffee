describe "String#gsub with pattern and replacement", ->

  # before :each do
  #   @kcode = $KCODE

  # after :each do
  #   $KCODE = @kcode

  xit "inserts the replacement around every character when the pattern collapses", ->
    expect( R("hello").gsub(//g, ".") ).toEqual R(".h.e.l.l.o.")

  xit "respects $KCODE when the pattern collapses", ->
    # str = "こにちわ"
    # reg = %r!!
    # $KCODE = "utf-8"
    # str.gsub(reg, ".") ).toEqual R(".こ.に.ち.わ.")

  it "doesn't freak out when replacing ^", ->
    expect( R("Text\n").gsub(/^/g, '.') ).toEqual R(".Text\n")
    # expect( R("Text\nFoo").gsub(/^/g, '.') ).toEqual R(".Text\n.Foo")

  it "returns a copy of self with all occurrences of pattern replaced with replacement", ->
    expect( R("hello").gsub(/[aeiou]/g, '*') ).toEqual R("h*ll*")

    str = "hello homely world. hah!"
    expect( R(str).gsub(/^h\S+\s*/g, "huh? ") ).toEqual R("huh? homely world. hah!")
    # \A is simply ^.
    # expect( R(str).gsub(/\Ah\S+\s*/g, "huh? ") ).toEqual R("huh? homely world. hah!")

  it "ignores a block if supplied", ->
    expect( R("food").gsub(/f/g, "g", -> 'w')  ).toEqual R("good")

  xit "supports \\G which matches at the beginning of the remaining (non-matched) string", ->
    str = "hello homely world. hah!"
    expect( R(str).gsub(/\Gh\S+\s*/g, "huh? ") ).toEqual R("huh? huh? world. hah!")

  xit "supports /i for ignoring case", ->
    str = "Hello. How happy are you?"
    expect( R(str).gsub(/h/ig, "j") ).toEqual R("jello. jow jappy are you?")
    expect( R(str).gsub(/H/ig, "j") ).toEqual R("jello. jow jappy are you?")

  it "doesn't interpret regexp metacharacters if pattern is a string", ->
    expect( R("12345").gsub('\d', 'a') ).toEqual R("12345")
    expect( R('\d').gsub('\d', 'a') ).toEqual R("a")

  it "replaces \\1 sequences with the regexp's corresponding capture", ->
    str = "hello"

    # expect( R(str).gsub(/([aeiou])/g, "<\1>") ).toEqual R("h<e>ll<o>")
    # expect( R(str).gsub(/(.)/g, '\1\1') ).toEqual R("hheelllloo")
    expect( R(str).gsub(/([aeiou])/g, "<$1>") ).toEqual R("h<e>ll<o>")
    expect( R(str).gsub(/(.)/g, '$1$1') ).toEqual R("hheelllloo")

    # expect( R(str).gsub(/.(.?)/g, '<\0>(\1)') ).toEqual R("<he>(e)<ll>(l)<o>()")
    # expect( R(str).gsub(/.(.)+/g, '\1') ).toEqual R("o")
    expect( R(str).gsub(/.(.?)/g, '<$&>($1)') ).toEqual R("<he>(e)<ll>(l)<o>()")
    expect( R(str).gsub(/.(.)+/g, '$1') ).toEqual R("o")

    # str = "ABCDEFGHIJKLabcdefghijkl"
    # re = /#{"(.)" * 12}/
    # expect( R(str).gsub(re, '\1') ).toEqual R("Aa")
    # expect( R(str).gsub(re, '\9') ).toEqual R("Ii")
    # # Only the first 9 captures can be accessed in MRI
    # expect( R(str).gsub(re, '\10') ).toEqual R("A0a0")

  xit "treats \\1 sequences without corresponding captures as empty strings", ->
    str = "hello!"

    # expect( R(str).gsub("", '<\1>') ).toEqual R("<>h<>e<>l<>l<>o<>!<>")
    # expect( R(str).gsub("h", '<\1>') ).toEqual R("<>ello!")

    # expect( R(str).gsub(//g, '<\1>') ).toEqual R("<>h<>e<>l<>l<>o<>!<>")
    # expect( R(str).gsub(/./g, '\1\2\3') ).toEqual R("")
    # expect( R(str).gsub(/.(.{20})?/g, '\1') ).toEqual R("")

  it "replaces \\& and \\0 with the complete match", ->
    str = "hello!"

    # expect( R(str).gsub("", '<$1>') ).toEqual R("<>h<>e<>l<>l<>o<>!<>")
    # expect( R(str).gsub("", '<$&>') ).toEqual R("<>h<>e<>l<>l<>o<>!<>")
    # expect( R(str).gsub("he", '<$1>') ).toEqual R("<he>llo!")
    # TODO implement:
    # expect( R(str).gsub("he", '<$&>') ).toEqual R("<he>llo!")
    # expect( R(str).gsub("l", '<$1>') ).toEqual R("he<l><l>o!")
    # expect( R(str).gsub("l", '<$&>') ).toEqual R("he<l><l>o!")

    # expect( R(str).gsub(//g, '<$1>') ).toEqual R("<>h<>e<>l<>l<>o<>!<>")
    # expect( R(str).gsub(//g, '<$&>') ).toEqual R("<>h<>e<>l<>l<>o<>!<>")

    # TODO: Note difference:
    # expect( R(str).gsub(/../g, '<$1>') ).toEqual R("<he><ll><o!>")
    expect( R(str).gsub(/(..)/g, '<$1>') ).toEqual R("<he><ll><o!>")
    expect( R(str).gsub(/../g, '<$&>') ).toEqual R("<he><ll><o!>")
    expect( R(str).gsub(/(.)./g, '<$&>') ).toEqual R("<he><ll><o!>")

  it "replaces \\` with everything before the current match", ->
    str = "hello!"

    expect( R(str).gsub("", '<$`>') ).toEqual R("<>h<h>e<he>l<hel>l<hell>o<hello>!<hello!>")
    expect( R(str).gsub("h", '<$`>') ).toEqual R("<>ello!")
    expect( R(str).gsub("l", '<$`>') ).toEqual R("he<he><hel>o!")
    expect( R(str).gsub("!", '<$`>') ).toEqual R("hello<hello>")

    expect( R(str).gsub(//g, '<$`>') ).toEqual R("<>h<h>e<he>l<hel>l<hell>o<hello>!<hello!>")
    expect( R(str).gsub(/../g, '<$`>') ).toEqual R("<><he><hell>")
    expect( R(str).gsub(/(..)/g, '<$`>') ).toEqual R("<><he><hell>")

  it "replaces \\' with everything after the current match", ->
    str = "hello!"

    expect( R(str).gsub("", '<$\'>') ).toEqual R("<hello!>h<ello!>e<llo!>l<lo!>l<o!>o<!>!<>")
    expect( R(str).gsub("h", '<$\'>') ).toEqual R("<ello!>ello!")
    expect( R(str).gsub("ll", '<$\'>') ).toEqual R("he<o!>o!")
    expect( R(str).gsub("!", '<$\'>') ).toEqual R("hello<>")

    # expect( R(str).gsub(//g, '<\\\'>') ).toEqual R("<hello!>h<ello!>e<llo!>l<lo!>l<o!>o<!>!<>")

    expect( R(str).gsub(/../g, "<$'>") ).toEqual R("<llo!><o!><>")
    expect( R(str).gsub(/../g, '<$\'>') ).toEqual R("<llo!><o!><>")

  xit "replaces \\+ with the last paren that actually matched", ->
    # str = "hello!"

    # expect( R(str).gsub(/(.)(.)/g, '\+') ).toEqual R("el!")
    # expect( R(str).gsub(/(.)(.)+/g, '\+') ).toEqual R("!")
    # expect( R(str).gsub(/(.)()/g, '\+') ).toEqual R("")
    # expect( R(str).gsub(/(.)(.{20})?/g, '<\+>') ).toEqual R("<h><e><l><l><o><!>")

    # str = "ABCDEFGHIJKLabcdefghijkl"
    # re = /#{"(.)" * 12}/
    # expect( R(str).gsub(re, '\+') ).toEqual R("Ll")

  xit "treats \\+ as an empty string if there was no captures", ->
    # expect( R("hello!").gsub(/./g, '\+') ).toEqual R("")

  it "maps \\\\ in replacement to \\", ->
    # TODO: doc difference
    expect( R("hello").gsub(/./g, '$$') ).toEqual R('$$$$$')

  it "leaves unknown \\x escapes in replacement untouched", ->
    # TODO: doc difference
    expect( R("foo").gsub(/./g, '$x') ).toEqual R('$x$x$x')
    expect( R("foo").gsub(/./g, '$y') ).toEqual R('$y$y$y')

  it "leaves \\ at the end of replacement untouched", ->
    expect( R("hello").gsub(/./g, 'hah$') ).toEqual R('hah$hah$hah$hah$hah$')

  xit "taints the result if the original string or replacement is tainted", ->
    # hello = "hello"
    # hello_t = "hello"
    # a = "a"
    # a_t = "a"
    # empty = ""
    # empty_t = ""

    # hello_t.taint; a_t.taint; empty_t.taint

    # hello_t.gsub(/./, a).tainted?.should == true
    # hello_t.gsub(/./, empty).tainted?.should == true

    # hello.gsub(/./, a_t).tainted?.should == true
    # hello.gsub(/./, empty_t).tainted?.should == true
    # hello.gsub(//, empty_t).tainted?.should == true

    # hello.gsub(//.taint, "foo").tainted?.should == false

  xdescribe 'ruby_version_is "1.9".', ->
    xit "untrusts the result if the original string or replacement is untrusted", ->
      # hello = "hello"
      # hello_t = "hello"
      # a = "a"
      # a_t = "a"
      # empty = ""
      # empty_t = ""

      # hello_t.untrust; a_t.untrust; empty_t.untrust

      # hello_t.gsub(/./, a).untrusted?.should == true
      # hello_t.gsub(/./, empty).untrusted?.should == true

      # hello.gsub(/./, a_t).untrusted?.should == true
      # hello.gsub(/./, empty_t).untrusted?.should == true
      # hello.gsub(//, empty_t).untrusted?.should == true

      # hello.gsub(//.untrust, "foo").untrusted?.should == false

  it "tries to convert pattern to a string using valueOf", ->
    pattern =
      valueOf: -> "."

    expect( R("hello.").gsub(pattern, "!") ).toEqual R("hello!")

  it "raises a TypeError when pattern can't be converted to a string", ->
    expect( -> R("hello").gsub([], "x")            ).toThrow('TypeError')
    expect( -> R("hello").gsub({}, "x")    ).toThrow('TypeError')
    expect( -> R("hello").gsub(null, "x")           ).toThrow('TypeError')

  it "tries to convert replacement to a string using valueOf", ->
    replacement =
      valueOf: -> "hello_replacement"

    expect( R("hello").gsub(/hello/g, replacement) ).toEqual R("hello_replacement")

  it "raises a TypeError when replacement can't be converted to a string", ->
    expect( -> R("hello").gsub(/[aeiou]/g, [])            ).toThrow('TypeError')
    expect( -> R("hello").gsub(/[aeiou]/g, {})    ).toThrow('TypeError')
    expect( -> R("hello").gsub(/[aeiou]/g, null)           ).toThrow('TypeError')

  xit "returns subclass instances when called on a subclass", ->
    expect( new StringSpecs.MyString("").gsub(//g, "") ).toBeInstanceOf(StringSpecs.MyString)
    expect( new StringSpecs.MyString("").gsub(/foo/g, "") ).toBeInstanceOf(StringSpecs.MyString)
    expect( new StringSpecs.MyString("foo").gsub(/foo/g, "") ).toBeInstanceOf(StringSpecs.MyString)
    expect( new StringSpecs.MyString("foo").gsub("foo", "") ).toBeInstanceOf(StringSpecs.MyString)

  # Note: $~ cannot be tested because mspec messes with it

#   it "sets $~ to MatchData of last match and nil when there's none", ->
#     'hello.'.gsub('hello', 'x')
#     $~[0].should == 'hello'

#     'hello.'.gsub('not', 'x')
#     $~.should == nil

#     'hello.'.gsub(/.(.)/, 'x')
#     $~[0].should == 'o.'

#     'hello.'.gsub(/not/, 'x')
#     $~.should == nil

describe 'ruby_version_is "1.9"', ->

  xdescribe "String#gsub with pattern and Hash", ->
    # TODO: implement this feature:

    # it "returns a copy of self with all occurrences of pattern replaced with the value of the corresponding hash key", ->
    #   expect(R("hello").gsub(/./g, {'l': 'L'} ) ).toEqual R("LL")
    #   expect(R("hello!").gsub(/(.)(.)/g, {'he': 'she ', 'll': 'said'} ) ).toEqual R('she said')
    #   expect(R("hello").gsub('l', {'l': 'el'} ) ).toEqual R('heelelo')

    # it "ignores keys that don't correspond to matches", ->
    #   expect(R("hello").gsub(/./g, {'z': 'L', 'h': 'b', 'o': 'ow'} ) ).toEqual R("bow")

    # it "returns an empty string if the pattern matches but the hash specifies no replacements", ->
    #   expect(R("hello").gsub(/./g, {'z': 'L'} ) ).toEqual R("")

    # it "ignores non-String keys", ->
    #   nonstring = {}
    #   expect(R("hello").gsub(/(ll)/g, {'ll': 'r', nonstring: 'z'} ) ).toEqual R("hero")

    # it "uses a key's value as many times as needed", ->
    #   expect(R("food").gsub(/o/g, {'o': '0'} ) ).toEqual R("f00d")

    # it "uses the hash's default value for missing keys", ->
    #   # hsh = new_hash
    #   # hsh.default='?'
    #   # hsh['o'] = '0'
    #   # expect(R("food").gsub(/./g, hsh) ).toEqual R("?00?")

    # it "coerces the hash values with #to_s", ->
    #   # hsh = new_hash
    #   # hsh.default=[]
    #   # hsh['o'] = 0
    #   # obj = mock('!')
    #   # obj.should_receive(:to_s).and_return('!')
    #   # hsh['!'] = obj
    #   # expect(R("food!").gsub(/./g, hsh) ).toEqual R("[]00[]!")

    # it "uses the hash's value set from default_proc for missing keys", ->
    #   # hsh = new_hash
    #   # hsh.default_proc = lambda { |k,v| 'lamb' }
    #   # expect(R("food!").gsub(/./g, hsh) ).toEqual R("lamblamblamblamblamb")

    # it "sets $~ to MatchData of last match and nil when there's none for access from outside", ->
    #   # expect(R('hello.').gsub('l', 'l' => 'L')
    #   # $~.begin(0) ).toEqual R(3)
    #   # $~[0].should == 'l'

    #   # 'hello.'.gsub('not', 'ot' => 'to')
    #   # $~.should == nil

    #   # 'hello.'.gsub(/.(.)/g, 'o' => ' hole')
    #   # $~[0].should == 'o.'

    #   # 'hello.'.gsub(/not/g, 'z' => 'glark')
    #   # $~.should == nil

    # it "doesn't interpolate special sequences like \\1 for the block's return value", ->
    #   repl = '$& $0 $1 $` $\' $+ $$ foo'
    #   expect( R("hello").gsub(/(.+)/g, {'hello': repl} ) ).toEqual R(repl)

#     it "untrusts the result if the original string is untrusted", ->
#       str = "Ghana".untrust
#       str.gsub(/[Aa]na/, 'ana' => '').untrusted?.should be_true

#     it "untrusts the result if a hash value is untrusted", ->
#       str = "Ghana"
#       str.gsub(/a$/, 'a' => 'di'.untrust).untrusted?.should be_true

#     it "taints the result if the original string is tainted", ->
#       str = "Ghana".taint
#       str.gsub(/[Aa]na/, 'ana' => '').tainted?.should be_true

#     it "taints the result if a hash value is tainted", ->
#       str = "Ghana"
#       str.gsub(/a$/, 'a' => 'di'.taint).tainted?.should be_true


#   describe "String#gsub! with pattern and Hash", ->

#     it "returns self with all occurrences of pattern replaced with the value of the corresponding hash key", ->
#       "hello".gsub!(/./, 'l' => 'L').should == "LL"
#       "hello!".gsub!(/(.)(.)/, 'he' => 'she ', 'll' => 'said').should == 'she said'
#       "hello".gsub!('l', 'l' => 'el').should == 'heelelo'

#     it "ignores keys that don't correspond to matches", ->
#       "hello".gsub!(/./, 'z' => 'L', 'h' => 'b', 'o' => 'ow').should == "bow"

#     it "replaces self with an empty string if the pattern matches but the hash specifies no replacements", ->
#       "hello".gsub!(/./, 'z' => 'L').should == ""

#     it "ignores non-String keys", ->
#       "hello".gsub!(/(ll)/, 'll' => 'r', :ll => 'z').should == "hero"

#     it "uses a key's value as many times as needed", ->
#       "food".gsub!(/o/, 'o' => '0').should == "f00d"

#     it "uses the hash's default value for missing keys", ->
#       hsh = new_hash
#       hsh.default='?'
#       hsh['o'] = '0'
#       "food".gsub!(/./, hsh).should == "?00?"

#     it "coerces the hash values with #to_s", ->
#       hsh = new_hash
#       hsh.default=[]
#       hsh['o'] = 0
#       obj = mock('!')
#       obj.should_receive(:to_s).and_return('!')
#       hsh['!'] = obj
#       "food!".gsub!(/./, hsh).should == "[]00[]!"

#     it "uses the hash's value set from default_proc for missing keys", ->
#       hsh = new_hash
#       hsh.default_proc = lambda { |k,v| 'lamb' }
#       "food!".gsub!(/./, hsh).should == "lamblamblamblamblamb"

#     it "sets $~ to MatchData of last match and nil when there's none for access from outside", ->
#       'hello.'.gsub!('l', 'l' => 'L')
#       $~.begin(0).should == 3
#       $~[0].should == 'l'

#       'hello.'.gsub!('not', 'ot' => 'to')
#       $~.should == nil

#       'hello.'.gsub!(/.(.)/, 'o' => ' hole')
#       $~[0].should == 'o.'

#       'hello.'.gsub!(/not/, 'z' => 'glark')
#       $~.should == nil

#     it "doesn't interpolate special sequences like \\1 for the block's return value", ->
#       repl = '\& \0 \1 \` \\\' \+ \\\\ foo'
#       "hello".gsub!(/(.+)/, 'hello' => repl ).should == repl

#     it "keeps untrusted state", ->
#       str = "Ghana".untrust
#       str.gsub!(/[Aa]na/, 'ana' => '').untrusted?.should be_true

#     it "untrusts self if a hash value is untrusted", ->
#       str = "Ghana"
#       str.gsub!(/a$/, 'a' => 'di'.untrust).untrusted?.should be_true

#     it "keeps tainted state", ->
#       str = "Ghana".taint
#       str.gsub!(/[Aa]na/, 'ana' => '').tainted?.should be_true

#     it "taints self if a hash value is tainted", ->
#       str = "Ghana"
#       str.gsub!(/a$/, 'a' => 'di'.taint).tainted?.should be_true

# end

# describe "String#gsub with pattern and block", ->
#   it "returns a copy of self with all occurrences of pattern replaced with the block's return value", ->
#     "hello".gsub(/./) { |s| s.succ + ' ' }.should == "i f m m p "
#     "hello!".gsub(/(.)(.)/) { |*a| a.inspect }.should == '["he"]["ll"]["o!"]'
#     "hello".gsub('l') { 'x'}.should == 'hexxo'

#   it "sets $~ for access from the block", ->
#     str = "hello"
#     str.gsub(/([aeiou])/) { "<#{$~[1]}>" }.should == "h<e>ll<o>"
#     str.gsub(/([aeiou])/) { "<#{$1}>" }.should == "h<e>ll<o>"
#     str.gsub("l") { "<#{$~[0]}>" }.should == "he<l><l>o"

#     offsets = []

#     str.gsub(/([aeiou])/) do
#       md = $~
#       md.string.should == str
#       offsets << md.offset(0)
#       str
#     end.should == "hhellollhello"

#     offsets.should == [[1, 2], [4, 5]]

#   it "restores $~ after leaving the block", ->
#     [/./, "l"].each do |pattern|
#       old_md = nil
#       "hello".gsub(pattern) do
#         old_md = $~
#         "ok".match(/./)
#         "x"

#       $~[0].should == old_md[0]
#       $~.string.should == "hello"

#   it "sets $~ to MatchData of last match and nil when there's none for access from outside", ->
#     'hello.'.gsub('l') { 'x' }
#     $~.begin(0).should == 3
#     $~[0].should == 'l'

#     'hello.'.gsub('not') { 'x' }
#     $~.should == nil

#     'hello.'.gsub(/.(.)/) { 'x' }
#     $~[0].should == 'o.'

#     'hello.'.gsub(/not/) { 'x' }
#     $~.should == nil

#   ruby_version_is ""..."1.9", ->
#     it "raises a RuntimeError if the string is modified while substituting", ->
#       str = "hello"
#       lambda { str.gsub(//) { str[0] = 'x' } }.should raise_error(RuntimeError)

#   it "doesn't interpolate special sequences like \\1 for the block's return value", ->
#     repl = '\& \0 \1 \` \\\' \+ \\\\ foo'
#     "hello".gsub(/(.+)/) { repl }.should == repl

#   it "converts the block's return value to a string using to_s", ->
#     replacement = mock('hello_replacement')
#     def replacement.to_s() "hello_replacement" end

#     "hello".gsub(/hello/) { replacement }.should == "hello_replacement"

#     obj = mock('ok')
#     def obj.to_s() "ok" end

#     "hello".gsub(/.+/) { obj }.should == "ok"

#   ruby_version_is "1.9", ->
#     it "untrusts the result if the original string or replacement is untrusted", ->
#       hello = "hello"
#       hello_t = "hello"
#       a = "a"
#       a_t = "a"
#       empty = ""
#       empty_t = ""

#       hello_t.untrust; a_t.untrust; empty_t.untrust

#       hello_t.gsub(/./) { a }.untrusted?.should == true
#       hello_t.gsub(/./) { empty }.untrusted?.should == true

#       hello.gsub(/./) { a_t }.untrusted?.should == true
#       hello.gsub(/./) { empty_t }.untrusted?.should == true
#       hello.gsub(//) { empty_t }.untrusted?.should == true

#       hello.gsub(//.untrust) { "foo" }.untrusted?.should == false
#   end

# describe "String#gsub! with pattern and replacement", ->
#   it "modifies self in place and returns self", ->
#     a = "hello"
#     a.gsub!(/[aeiou]/, '*').should equal(a)
#     a.should == "h*ll*"

#   it "taints self if replacement is tainted", ->
#     a = "hello"
#     a.gsub!(/./.taint, "foo").tainted?.should == false
#     a.gsub!(/./, "foo".taint).tainted?.should == true

#   ruby_version_is "1.9", ->
#     it "untrusts self if replacement is untrusted", ->
#       a = "hello"
#       a.gsub!(/./.untrust, "foo").untrusted?.should == false
#       a.gsub!(/./, "foo".untrust).untrusted?.should == true

#   it "returns nil if no modifications were made", ->
#     a = "hello"
#     a.gsub!(/z/, '*').should == nil
#     a.gsub!(/z/, 'z').should == nil
#     a.should == "hello"

#   ruby_version_is ""..."1.9", ->
#     it "does not raise an error if the frozen string would not be modified", ->
#       s = "hello"
#       s.freeze

#       s.gsub!(/ROAR/, "x").should be_nil

#     it "raises a TypeError if the frozen string would be modified", ->
#       s = "hello"
#       s.freeze

#       lambda { s.gsub!(/e/, "e")       }.should raise_error(TypeError)
#       lambda { s.gsub!(/[aeiou]/, '*') }.should raise_error(TypeError)

#   # See [ruby-core:23666]
#   ruby_version_is "1.9", ->
#     it "raises a RuntimeError when self is frozen", ->
#       s = "hello"
#       s.freeze

#       lambda { s.gsub!(/ROAR/, "x")    }.should raise_error(RuntimeError)
#       lambda { s.gsub!(/e/, "e")       }.should raise_error(RuntimeError)
#       lambda { s.gsub!(/[aeiou]/, '*') }.should raise_error(RuntimeError)
#   end

# describe "String#gsub! with pattern and block", ->
#   it "modifies self in place and returns self", ->
#     a = "hello"
#     a.gsub!(/[aeiou]/) { '*' }.should equal(a)
#     a.should == "h*ll*"

#   it "taints self if block's result is tainted", ->
#     a = "hello"
#     a.gsub!(/./.taint) { "foo" }.tainted?.should == false
#     a.gsub!(/./) { "foo".taint }.tainted?.should == true

#   ruby_version_is "1.9", ->
#     it "untrusts self if block's result is untrusted", ->
#       a = "hello"
#       a.gsub!(/./.untrust) { "foo" }.untrusted?.should == false
#       a.gsub!(/./) { "foo".untrust }.untrusted?.should == true

#   it "returns nil if no modifications were made", ->
#     a = "hello"
#     a.gsub!(/z/) { '*' }.should == nil
#     a.gsub!(/z/) { 'z' }.should == nil
#     a.should == "hello"

#   ruby_version_is ""..."1.9", ->
#     it "does not raise an error if the frozen string would not be modified", ->
#       s = "hello"
#       s.freeze

#       s.gsub!(/ROAR/) { "x" }.should be_nil

#     deviates_on :rubinius do
#       # MRI 1.8.x is inconsistent here, raising a TypeError when not passed
#       # a block and a RuntimeError when passed a block. This is arguably a
#       # bug in MRI. In 1.9, both situations raise a RuntimeError.
#       it "raises a TypeError if the frozen string would be modified", ->
#         s = "hello"
#         s.freeze

#         lambda { s.gsub!(/e/)       { "e" } }.should raise_error(TypeError)
#         lambda { s.gsub!(/[aeiou]/) { '*' } }.should raise_error(TypeError)

#     not_compliant_on :rubinius do
#       it "raises a RuntimeError if the frozen string would be modified", ->
#         s = "hello"
#         s.freeze

#         lambda { s.gsub!(/e/)       { "e" } }.should raise_error(RuntimeError)
#         lambda { s.gsub!(/[aeiou]/) { '*' } }.should raise_error(RuntimeError)

#   # See [ruby-core:23663]
#   ruby_version_is "1.9", ->
#     it "raises a RuntimeError when self is frozen", ->
#       s = "hello"
#       s.freeze

#       lambda { s.gsub!(/ROAR/)    { "x" } }.should raise_error(RuntimeError)
#       lambda { s.gsub!(/e/)       { "e" } }.should raise_error(RuntimeError)
#       lambda { s.gsub!(/[aeiou]/) { '*' } }.should raise_error(RuntimeError)
