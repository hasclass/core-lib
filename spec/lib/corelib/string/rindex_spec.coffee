describe "String#rindex with object", ->
  it "raises a TypeError if obj isn't a String, Fixnum or Regexp", ->
    expect( -> R("hello").rindex({}) ).toThrow('TypeError')
    expect( -> R("hello").rindex([]) ).toThrow('TypeError')

  it "doesn't try to convert obj to an integer via to_int", ->
    obj =
      to_int: -> throw "do not call"
    expect( -> R("hello").rindex(obj) ).toThrow('TypeError')

  # ruby_bug "#", "1.8.6", -> # Fixed at MRI 1.8.7
  #   it "tries to convert obj to a string via to_str", ->
  #     obj = mock('lo')
  #     def obj.to_str() "lo" end
  #     "hello".rindex(obj).should == "hello".rindex("lo")

  #     obj = mock('o')
  #     def obj.respond_to?(arg, *) true end
  #     def obj.method_missing(*args) "o" end
  #     "hello".rindex(obj).should == "hello".rindex("o")
  # end

# Ruby 1.9 doesn't support the String#rindex(Fixnum) invocation. However,
# confusingly, many of the tests in this block pass because it also changes
# the semantics of ?l, where _l_ is a character, to return the character
# corresponding to _l_; not the Fixnum. Regardless, it doesn't make sense to
# have a describe block for "String#rindex with Fixnum" on 1.9 when 1.9
# doesn't support that invocation. The other tests in this file exercise
# String#rindex(?l) on 1.9 inadvertently because they test for
# String#rindex(str).
# ruby_version_is ""..."1.9", ->
#   describe "String#rindex with Fixnum", ->
#     it "returns the index of the last occurrence of the given character", ->
#       "hello".rindex(?e).should == 1
#       "hello".rindex(?l).should == 3

#     it "doesn't use fixnum % 256", ->
#       "hello".rindex(?e + 256 * 3).should == nil
#       "hello".rindex(-(256 - ?e)).should == nil

#     it "starts the search at the given offset", ->
#       "blablabla".rindex(?b, 0).should == 0
#       "blablabla".rindex(?b, 1).should == 0
#       "blablabla".rindex(?b, 2).should == 0
#       "blablabla".rindex(?b, 3).should == 3
#       "blablabla".rindex(?b, 4).should == 3
#       "blablabla".rindex(?b, 5).should == 3
#       "blablabla".rindex(?b, 6).should == 6
#       "blablabla".rindex(?b, 7).should == 6
#       "blablabla".rindex(?b, 8).should == 6
#       "blablabla".rindex(?b, 9).should == 6
#       "blablabla".rindex(?b, 10).should == 6

#       "blablabla".rindex(?a, 2).should == 2
#       "blablabla".rindex(?a, 3).should == 2
#       "blablabla".rindex(?a, 4).should == 2
#       "blablabla".rindex(?a, 5).should == 5
#       "blablabla".rindex(?a, 6).should == 5
#       "blablabla".rindex(?a, 7).should == 5
#       "blablabla".rindex(?a, 8).should == 8
#       "blablabla".rindex(?a, 9).should == 8
#       "blablabla".rindex(?a, 10).should == 8

#     it "starts the search at offset + self.length if offset is negative", ->
#       str = "blablabla"

#       [?a, ?b].each do |needle|
#         (-str.length .. -1).each do |offset|
#           str.rindex(needle, offset).should ==
#           str.rindex(needle, offset + str.length)

#     it "returns nil if the character isn't found", ->
#       "hello".rindex(0).should == nil

#       "hello".rindex(?H).should == nil
#       "hello".rindex(?z).should == nil
#       "hello".rindex(?o, 2).should == nil

#       "blablabla".rindex(?a, 0).should == nil
#       "blablabla".rindex(?a, 1).should == nil

#       "blablabla".rindex(?a, -8).should == nil
#       "blablabla".rindex(?a, -9).should == nil

#       "blablabla".rindex(?b, -10).should == nil
#       "blablabla".rindex(?b, -20).should == nil

#     it "tries to convert start_offset to an integer via to_int", ->
#       obj = mock('5')
#       def obj.to_int() 5 end
#       "str".rindex(?s, obj).should == 0

#       obj = mock('5')
#       def obj.respond_to?(arg, *) true end
#       def obj.method_missing(*args); 5; end
#       "str".rindex(?s, obj).should == 0

#     it "raises a TypeError when given offset is nil", ->
#       lambda { "str".rindex(?s, nil) }.should raise_error(TypeError)
#       lambda { "str".rindex(?t, nil) }.should raise_error(TypeError)
#   end

describe "String#rindex with String", ->
  it "behaves the same as String#rindex(char) for one-character strings", ->
    R(["blablabla", "hello cruel world...!"]).each (str) ->
      R(str).split("").uniq().each (str) ->
        chr = str.to_native()[0]
        expect( str.rindex(str) ).toEqual str.rindex(chr)

        R(0).upto (str.size() + 1), (start) ->
          expect( str.rindex(str, start) ).toEqual str.rindex(chr, start)

        R(-str.size() - 1).upto -1, (start) ->
          expect( str.rindex(str, start) ).toEqual str.rindex(chr, start)

  # On 1.9 ?chr, where _chr_ is a character returns the character as a string.
  # The test below repeats the one above but uses the ?l notation for single
  # characters instead.
  # ruby_version_is "1.9", ->
  #   it "behaves the same as String#rindex(?char) for one-character strings", ->
  #     ["blablabla", "hello cruel world...!"].each do |str|
  #       str.split("").uniq.each do |str|
  #         chr = str[0] =~ / / ? str[0] : eval("?#{str[0]}")
  #         str.rindex(str).should == str.rindex(chr)

  #         0.upto(str.size + 1) do |start|
  #           str.rindex(str, start).should == str.rindex(chr, start)

  #         (-str.size - 1).upto(-1) do |start|
  #           str.rindex(str, start).should == str.rindex(chr, start)



  it "returns the index of the last occurrence of the given substring", ->
    expect( R("blablabla").rindex("")          ).toEqual R(9)
    expect( R("blablabla").rindex("a")         ).toEqual R(8)
    expect( R("blablabla").rindex("la")        ).toEqual R(7)
    expect( R("blablabla").rindex("bla")       ).toEqual R(6)
    expect( R("blablabla").rindex("abla")      ).toEqual R(5)
    expect( R("blablabla").rindex("labla")     ).toEqual R(4)
    expect( R("blablabla").rindex("blabla")    ).toEqual R(3)
    expect( R("blablabla").rindex("ablabla")   ).toEqual R(2)
    expect( R("blablabla").rindex("lablabla")  ).toEqual R(1)
    expect( R("blablabla").rindex("blablabla") ).toEqual R(0)

    expect( R("blablabla").rindex("l")        ).toEqual R(7)
    expect( R("blablabla").rindex("bl")       ).toEqual R(6)
    expect( R("blablabla").rindex("abl")      ).toEqual R(5)
    expect( R("blablabla").rindex("labl")     ).toEqual R(4)
    expect( R("blablabla").rindex("blabl")    ).toEqual R(3)
    expect( R("blablabla").rindex("ablabl")   ).toEqual R(2)
    expect( R("blablabla").rindex("lablabl")  ).toEqual R(1)
    expect( R("blablabla").rindex("blablabl") ).toEqual R(0)

    expect( R("blablabla").rindex("b")       ).toEqual R(6)
    expect( R("blablabla").rindex("ab")      ).toEqual R(5)
    expect( R("blablabla").rindex("lab")     ).toEqual R(4)
    expect( R("blablabla").rindex("blab")    ).toEqual R(3)
    expect( R("blablabla").rindex("ablab")   ).toEqual R(2)
    expect( R("blablabla").rindex("lablab")  ).toEqual R(1)
    expect( R("blablabla").rindex("blablab") ).toEqual R(0)

  it "doesn't set $~", ->
    R['$~'] = null

    R('hello.').rindex('ll')
    expect( R['$~'] ).toEqual null

  it "ignores string subclasses", ->
    expect( R("blablabla").rindex(new StringSpecs.MyString("bla")) ).toEqual R(6)
    expect( new StringSpecs.MyString("blablabla").rindex("bla") ).toEqual R(6)
    expect( new StringSpecs.MyString("blablabla").rindex(new StringSpecs.MyString("bla")) ).toEqual R(6)

  it "starts the search at the given offset", ->
    expect( R("blablabla").rindex("bl", 0) ).toEqual R(0)
    expect( R("blablabla").rindex("bl", 1) ).toEqual R(0)
    expect( R("blablabla").rindex("bl", 2) ).toEqual R(0)
    expect( R("blablabla").rindex("bl", 3) ).toEqual R(3)

    expect( R("blablabla").rindex("bla", 0) ).toEqual R(0)
    expect( R("blablabla").rindex("bla", 1) ).toEqual R(0)
    expect( R("blablabla").rindex("bla", 2) ).toEqual R(0)
    expect( R("blablabla").rindex("bla", 3) ).toEqual R(3)

    expect( R("blablabla").rindex("blab", 0) ).toEqual R(0)
    expect( R("blablabla").rindex("blab", 1) ).toEqual R(0)
    expect( R("blablabla").rindex("blab", 2) ).toEqual R(0)
    expect( R("blablabla").rindex("blab", 3) ).toEqual R(3)
    expect( R("blablabla").rindex("blab", 6) ).toEqual R(3)
    expect( R("blablablax").rindex("blab", 6) ).toEqual R(3)

    expect( R("blablabla").rindex("la", 1) ).toEqual R(1)
    expect( R("blablabla").rindex("la", 2) ).toEqual R(1)
    expect( R("blablabla").rindex("la", 3) ).toEqual R(1)
    expect( R("blablabla").rindex("la", 4) ).toEqual R(4)

    expect( R("blablabla").rindex("lab", 1) ).toEqual R(1)
    expect( R("blablabla").rindex("lab", 2) ).toEqual R(1)
    expect( R("blablabla").rindex("lab", 3) ).toEqual R(1)
    expect( R("blablabla").rindex("lab", 4) ).toEqual R(4)

    expect( R("blablabla").rindex("ab", 2) ).toEqual R(2)
    expect( R("blablabla").rindex("ab", 3) ).toEqual R(2)
    expect( R("blablabla").rindex("ab", 4) ).toEqual R(2)
    expect( R("blablabla").rindex("ab", 5) ).toEqual R(5)

    expect( R("blablabla").rindex("", 0) ).toEqual R(0)
    expect( R("blablabla").rindex("", 1) ).toEqual R(1)
    expect( R("blablabla").rindex("", 2) ).toEqual R(2)
    expect( R("blablabla").rindex("", 7) ).toEqual R(7)
    expect( R("blablabla").rindex("", 8) ).toEqual R(8)
    expect( R("blablabla").rindex("", 9) ).toEqual R(9)
    expect( R("blablabla").rindex("", 10) ).toEqual R(9)

  it "starts the search at offset + self.length if offset is negative", ->
    str = R("blablabla")

    R(["bl", "bla", "blab", "la", "lab", "ab", ""]).each (needle) ->
      R(-str.length).upto(-1).each (offset) ->
        expect( str.rindex(needle, offset) ).toEqual str.rindex(needle, offset + str.length)

  it "returns nil if the substring isn't found", ->
    expect( R("blablabla").rindex("B")            ).toEqual null
    expect( R("blablabla").rindex("z")            ).toEqual null
    expect( R("blablabla").rindex("BLA")          ).toEqual null
    expect( R("blablabla").rindex("blablablabla") ).toEqual null

    expect( R("hello").rindex("lo", 0) ).toEqual null
    expect( R("hello").rindex("lo", 1) ).toEqual null
    expect( R("hello").rindex("lo", 2) ).toEqual null

    expect( R("hello").rindex("llo", 0) ).toEqual null
    expect( R("hello").rindex("llo", 1) ).toEqual null

    expect( R("hello").rindex("el", 0)  ).toEqual null
    expect( R("hello").rindex("ello", 0)).toEqual null

    expect( R("hello").rindex("", -6)   ).toEqual null
    expect( R("hello").rindex("", -7)   ).toEqual null

    expect( R("hello").rindex("h", -6)  ).toEqual null

  it "tries to convert start_offset to an integer via to_int", ->
    obj =
      to_int: -> R(5)

    expect( R("str").rindex("st", obj) ).toEqual R(0)

    # TODO: does not currently use respond_to to check if to_int exists.
    #obj = mock('5')
    #def obj.respond_to?(arg, *) true end
    #def obj.method_missing(*args) 5 end
    #"str".rindex("st", obj).should == 0

  it "raises a TypeError when given offset is nil", ->
    expect( -> R("str").rindex("st", null) ).toThrow('TypeError')

describe "String#rindex with Regexp", ->
  it "behaves the same as String#rindex(string) for escaped string regexps", ->
    R(["blablabla", "hello cruel world...!"]).each (str) ->
      R(["", "b", "bla", "lab", "o c", "d."]).each (needle) ->
        str = R(str)
        regexp = R.Regexp.new(R.Regexp.quote(needle))
        expect( str.rindex(regexp) ).toEqual str.rindex(needle)

        R(0).upto str.size() + 1, (start) ->
          expect( str.rindex(regexp, start) ).toEqual str.rindex(needle, start)

        R(-str.size() - 1).upto -1, (start) ->
          expect( str.rindex(regexp, start) ).toEqual str.rindex(needle, start)

  it "returns the index of the first match from the end of string of regexp", ->
    expect( R("blablabla").rindex(/bla/)  ).toEqual R(6)
    expect( R("blablabla").rindex(/BLA/i) ).toEqual R(6)

    expect( R("blablabla").rindex(/.{0}/) ).toEqual R(9)
    expect( R("blablabla").rindex(/.{1}/) ).toEqual R(8)
    expect( R("blablabla").rindex(/.{2}/) ).toEqual R(7)
    expect( R("blablabla").rindex(/.{6}/) ).toEqual R(3)
    expect( R("blablabla").rindex(/.{9}/) ).toEqual R(0)

    expect( R("blablabla").rindex(/.*/) ).toEqual R(9)
    expect( R("blablabla").rindex(/.+/) ).toEqual R(8)

    expect( R("blablabla").rindex(/bla|a/) ).toEqual R(8)

    # DOCUMENT: \A, \Z not available
    # expect( R("blablabla"  ).rindex(/\A/) ).toEqual R(0)
    # expect( R("blablabla"  ).rindex(/\Z/) ).toEqual R(9)
    # expect( R("blablabla"  ).rindex(/\z/) ).toEqual R(9)
    # expect( R("blablabla\n").rindex(/\Z/) ).toEqual R(10)
    # expect( R("blablabla\n").rindex(/\z/) ).toEqual R(10)

    expect( R("blablabla"  ).rindex(/^/) ).toEqual R(0)
    # DOCUMENT: different behaviour for new lines
    # expect( R("\nblablabla").rindex(/^/) ).toEqual R(1)
    # expect( R("b\nlablabla").rindex(/^/) ).toEqual R(2)
    expect( R("blablabla"  ).rindex(/$/) ).toEqual R(9)

    expect( R("blablabla"  ).rindex(/.l./) ).toEqual R(6)

  # TODO: Handle this!
  xit "sets $~ to MatchData of match and nil when there's none", ->
    R('hello.').rindex(/.(.)/)
    expect( R['$~'] ).toEqual 'o.'

    R('hello.').rindex(/not/)
    expect( R['$~'] ).toEqual null

  it "starts the search at the given offset", ->
    expect( R("blablabla").rindex(/.{0}/, 5) ).toEqual R(5)
    expect( R("blablabla").rindex(/.{1}/, 5) ).toEqual R(5)
    expect( R("blablabla").rindex(/.{2}/, 5) ).toEqual R(5)
    expect( R("blablabla").rindex(/.{3}/, 5) ).toEqual R(5)
    expect( R("blablabla").rindex(/.{4}/, 5) ).toEqual R(5)

    expect( R("blablabla").rindex(/.{0}/, 3) ).toEqual R(3)
    expect( R("blablabla").rindex(/.{1}/, 3) ).toEqual R(3)
    expect( R("blablabla").rindex(/.{2}/, 3) ).toEqual R(3)
    expect( R("blablabla").rindex(/.{5}/, 3) ).toEqual R(3)
    expect( R("blablabla").rindex(/.{6}/, 3) ).toEqual R(3)

    expect( R("blablabla").rindex(/.l./, 0) ).toEqual R(0)
    expect( R("blablabla").rindex(/.l./, 1) ).toEqual R(0)
    expect( R("blablabla").rindex(/.l./, 2) ).toEqual R(0)
    expect( R("blablabla").rindex(/.l./, 3) ).toEqual R(3)

    expect( R("blablablax").rindex(/.x/, 10) ).toEqual R(8)
    expect( R("blablablax").rindex(/.x/, 9) ).toEqual R(8)
    expect( R("blablablax").rindex(/.x/, 8) ).toEqual R(8)

    expect( R("blablablax").rindex(/..x/, 10) ).toEqual R(7)
    expect( R("blablablax").rindex(/..x/, 9) ).toEqual R(7)
    expect( R("blablablax").rindex(/..x/, 8) ).toEqual R(7)
    expect( R("blablablax").rindex(/..x/, 7) ).toEqual R(7)

    # TODO:
    # expect( R("blablabla\n").rindex(/\Z/, 9) ).toEqual R(9)

  it "starts the search at offset + self.length if offset is negative", ->
    str = R("blablabla")

    R(["bl", "bla", "blab", "la", "lab", "ab", ""]).each (needle) ->
      needle = R(needle)
      R(-str.length).upto(-1).each (offset) ->
        expect( str.rindex(needle, offset) ).toEqual str.rindex(needle, offset + str.length)

  it "returns nil if the substring isn't found", ->
    expect( R("blablabla").rindex(/BLA/)     ).toEqual null
    expect( R("blablabla").rindex(/.{10}/)   ).toEqual null
    expect( R("blablablax").rindex(/.x/, 7)  ).toEqual null
    expect( R("blablablax").rindex(/..x/, 6) ).toEqual null

    # TODO:
    # expect( R("blablabla").rindex(/\Z/, 5)   ).toEqual null
    # expect( R("blablabla").rindex(/\z/, 5)   ).toEqual null
    # expect( R("blablabla\n").rindex(/\z/, 9) ).toEqual null

  xit "supports \\G which matches at the given start offset", ->
  #   "helloYOU.".rindex(/YOU\G/, 8).should == 5
  #   "helloYOU.".rindex(/YOU\G/).should == nil

  #   idx = "helloYOUall!".index("YOU")
  #   re = /YOU.+\G.+/
  #   # The # marks where \G will match.
  #   [
  #     ["helloYOU#all.", nil],
  #     ["helloYOUa#ll.", idx],
  #     ["helloYOUal#l.", idx],
  #     ["helloYOUall#.", idx],
  #     ["helloYOUall.#", nil]
  #   ].each do |i|
  #     start = i[0].index("#")
  #     str = i[0].delete("#")
      # str.rindex(re, start).should == i[1]

  it "tries to convert start_offset to an integer via to_int", ->
    obj =
      to_int: -> R(5)
    expect( R("str").rindex(/../, obj) ).toEqual R(1)

    # TODO: special case? document
    # obj = mock('5')
    # def obj.respond_to?(arg, *) true end
    # def obj.method_missing(*args); 5; end
    # "str".rindex(/../, obj).should == 1

  it "raises a TypeError when given offset is nil", ->
    expect( -> R("str").rindex(/../, null) ).toThrow('TypeError')

#   ruby_version_is "1.9.2", ->
#     it "reverse matches multibyte UTF-8 chars", ->
#       StringSpecs::UTF8Encoding.egrave.rindex(/[\w\W]/).should == 0
