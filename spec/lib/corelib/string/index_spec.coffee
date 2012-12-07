# TODO:: FINISH

describe "String#index with object", ->
  it "raises a TypeError if obj isn't a String, Fixnum or Regexp", ->
    expect( -> R("hello").index({}) ).toThrow('TypeError')
    expect( -> R("hello").index([]) ).toThrow('TypeError')

  it "doesn't try to convert obj to an Integer via to_int", ->
    obj = {}
    expect( -> R("hello").index(obj) ).toThrow('TypeError')

  it "tries to convert obj to a string via to_str", ->
    obj =
      to_str: -> R("lo")
    expect( R("hello").index(obj) ).toEqual R("hello").index("lo")

describe "String#index with String", ->
  it "behaves the same as String#index(char) for one-character strings", ->
    for str in ["blablabla", "hello cruel world...!"]
      str = R(str)
      str.split("").uniq().each (str) ->
        chr = str.chr()
        expect( str.index(str) ).toEqual str.index(chr)

        R(0).upto str.length + 1, (start) ->
          expect( str.index(str, start) ).toEqual str.index(chr, start)

        R(-str.length - 1).upto -1, (start) ->
          expect( str.index(str, start) ).toEqual str.index(chr, start)

  it "returns the index of the first occurrence of the given substring", ->
    expect( R("blablabla").index("") ).toEqual R(0)
    expect( R("blablabla").index("b") ).toEqual R(0)
    expect( R("blablabla").index("bla") ).toEqual R(0)
    expect( R("blablabla").index("blabla") ).toEqual R(0)
    expect( R("blablabla").index("blablabla") ).toEqual R(0)

    expect( R("blablabla").index("l") ).toEqual R(1)
    expect( R("blablabla").index("la") ).toEqual R(1)
    expect( R("blablabla").index("labla") ).toEqual R(1)
    expect( R("blablabla").index("lablabla") ).toEqual R(1)

    expect( R("blablabla").index("a") ).toEqual R(2)
    expect( R("blablabla").index("abla") ).toEqual R(2)
    expect( R("blablabla").index("ablabla") ).toEqual R(2)

  it "doesn't set $~", ->
    R['$~'] = null

    R('hello.').index('ll')
    expect( R['$~'] ).toEqual null

  it "ignores string subclasses", ->
    expect( R("blablabla").index(new StringSpecs.MyString("bla")) ).toEqual R(0)
    expect( new StringSpecs.MyString("blablabla").index("bla")    ).toEqual R(0)
    expect( new StringSpecs.MyString("blablabla").index(new StringSpecs.MyString("bla")) ).toEqual R(0)

  it "starts the search at the given offset", ->
    expect( R("blablabla").index("bl", 0) ).toEqual R(0)
    expect( R("blablabla").index("bl", 1) ).toEqual R(3)
    expect( R("blablabla").index("bl", 2) ).toEqual R(3)
    expect( R("blablabla").index("bl", 3) ).toEqual R(3)

    expect( R("blablabla").index("bla", 0) ).toEqual R(0)
    expect( R("blablabla").index("bla", 1) ).toEqual R(3)
    expect( R("blablabla").index("bla", 2) ).toEqual R(3)
    expect( R("blablabla").index("bla", 3) ).toEqual R(3)

    expect( R("blablabla").index("blab", 0) ).toEqual R(0)
    expect( R("blablabla").index("blab", 1) ).toEqual R(3)
    expect( R("blablabla").index("blab", 2) ).toEqual R(3)
    expect( R("blablabla").index("blab", 3) ).toEqual R(3)

    expect( R("blablabla").index("la", 1) ).toEqual R(1)
    expect( R("blablabla").index("la", 2) ).toEqual R(4)
    expect( R("blablabla").index("la", 3) ).toEqual R(4)
    expect( R("blablabla").index("la", 4) ).toEqual R(4)

    expect( R("blablabla").index("lab", 1) ).toEqual R(1)
    expect( R("blablabla").index("lab", 2) ).toEqual R(4)
    expect( R("blablabla").index("lab", 3) ).toEqual R(4)
    expect( R("blablabla").index("lab", 4) ).toEqual R(4)

    expect( R("blablabla").index("ab", 2) ).toEqual R(2)
    expect( R("blablabla").index("ab", 3) ).toEqual R(5)
    expect( R("blablabla").index("ab", 4) ).toEqual R(5)
    expect( R("blablabla").index("ab", 5) ).toEqual R(5)

    expect( R("blablabla").index("", 0) ).toEqual R(0)
    expect( R("blablabla").index("", 1) ).toEqual R(1)
    expect( R("blablabla").index("", 2) ).toEqual R(2)
    expect( R("blablabla").index("", 7) ).toEqual R(7)
    expect( R("blablabla").index("", 8) ).toEqual R(8)
    expect( R("blablabla").index("", 9) ).toEqual R(9)

  it "starts the search at offset + self.length if offset is negative", ->
    str = R("blablabla")

    for needle in ["bl", "bla", "blab", "la", "lab", "ab", ""]
      for offset in [-str.length .. -1]
        expect( str.index(needle, offset)).toEqual(str.index(needle, offset + str.length))

  it "returns nil if the substring isn't found", ->
    expect( R("blablabla").index("B")  ).toEqual null
    expect( R("blablabla").index("z")  ).toEqual null
    expect( R("blablabla").index("BLA")  ).toEqual null
    expect( R("blablabla").index("blablablabla")  ).toEqual null
    expect( R("blablabla").index("", 10)  ).toEqual null

    expect( R("hello").index("he", 1)  ).toEqual null
    expect( R("hello").index("he", 2)  ).toEqual null

  it "converts start_offset to an integer via to_int", ->
    obj =
      to_int: -> R(1)
    expect( R("RWOARW").index("RW", obj) ).toEqual R(4)

# describe "String#index with Regexp", ->
#   it "behaves the same as String#index(string) for escaped string regexps", ->
#     ["blablabla", "hello cruel world...!"].each do |str|
#       ["", "b", "bla", "lab", "o c", "d."].each do |needle|
#         regexp = Regexp.new(Regexp.escape(needle))
#         str.index(regexp).should == str.index(needle)

#         0.upto(str.size + 1) do |start|
#           str.index(regexp, start).should == str.index(needle, start)

#         (-str.size - 1).upto(-1) do |start|
#           str.index(regexp, start).should == str.index(needle, start)

#   it "returns the index of the first match of regexp", ->
#     "blablabla".index(/bla/).should == 0
#     "blablabla".index(/BLA/i).should == 0

#     "blablabla".index(/.{0}/).should == 0
#     "blablabla".index(/.{6}/).should == 0
#     "blablabla".index(/.{9}/).should == 0

#     "blablabla".index(/.*/).should == 0
#     "blablabla".index(/.+/).should == 0

#     "blablabla".index(/lab|b/).should == 0

#     "blablabla".index(/\A/).should == 0
#     "blablabla".index(/\Z/).should == 9
#     "blablabla".index(/\z/).should == 9
#     "blablabla\n".index(/\Z/).should == 9
#     "blablabla\n".index(/\z/).should == 10

#     "blablabla".index(/^/).should == 0
#     "\nblablabla".index(/^/).should == 0
#     "b\nablabla".index(/$/).should == 1
#     "bl\nablabla".index(/$/).should == 2

#     "blablabla".index(/.l./).should == 0

#   it "sets $~ to MatchData of match and nil when there's none", ->
#     'hello.'.index(/.(.)/)
#     $~[0].should == 'he'

#     'hello.'.index(/not/)
#     $~.should == nil

#   it "starts the search at the given offset", ->
#     "blablabla".index(/.{0}/, 5).should == 5
#     "blablabla".index(/.{1}/, 5).should == 5
#     "blablabla".index(/.{2}/, 5).should == 5
#     "blablabla".index(/.{3}/, 5).should == 5
#     "blablabla".index(/.{4}/, 5).should == 5

#     "blablabla".index(/.{0}/, 3).should == 3
#     "blablabla".index(/.{1}/, 3).should == 3
#     "blablabla".index(/.{2}/, 3).should == 3
#     "blablabla".index(/.{5}/, 3).should == 3
#     "blablabla".index(/.{6}/, 3).should == 3

#     "blablabla".index(/.l./, 0).should == 0
#     "blablabla".index(/.l./, 1).should == 3
#     "blablabla".index(/.l./, 2).should == 3
#     "blablabla".index(/.l./, 3).should == 3

#     "xblaxbla".index(/x./, 0).should == 0
#     "xblaxbla".index(/x./, 1).should == 4
#     "xblaxbla".index(/x./, 2).should == 4

#     "blablabla\n".index(/\Z/, 9).should == 9

#   it "starts the search at offset + self.length if offset is negative", ->
#     str = "blablabla"

#     ["bl", "bla", "blab", "la", "lab", "ab", ""].each do |needle|
#       (-str.length .. -1).each do |offset|
#         str.index(needle, offset).should ==
#         str.index(needle, offset + str.length)

#   it "returns nil if the substring isn't found", ->
#     "blablabla".index(/BLA/).should == nil

#     "blablabla".index(/.{10}/).should == nil
#     "blaxbla".index(/.x/, 3).should == nil
#     "blaxbla".index(/..x/, 2).should == nil

#   it "returns nil if the Regexp matches the empty string and the offset is out of range", ->
#     "ruby".index(//,12).should be_nil

#   it "supports \\G which matches at the given start offset", ->
#     "helloYOU.".index(/\GYOU/, 5).should == 5
#     "helloYOU.".index(/\GYOU/).should == nil

#     re = /\G.+YOU/
#     # The # marks where \G will match.
#     [
#       ["#hi!YOUall.", 0],
#       ["h#i!YOUall.", 1],
#       ["hi#!YOUall.", 2],
#       ["hi!#YOUall.", nil]
#     ].each do |spec|

#       start = spec[0].index("#")
#       str = spec[0].delete("#")

#       str.index(re, start).should == spec[1]

#   it "converts start_offset to an integer via to_int", ->
#     obj = mock('1')
#     obj.should_receive(:to_int).and_return(1)
#     "RWOARW".index(/R./, obj).should == 4


# TODO: needed?
# ruby_version_is ""..."1.9", ->
#   describe "String#index with Fixnum", ->
#     it "returns the index of the first occurrence of the given character", ->
#       "hello".index(?e).should == 1
#       "hello".index(?l).should == 2

#     it "character values over 255 (256th ASCII character) always result in nil", ->
#       # A naive implementation could try to use % 256
#       "hello".index(?e + 256 * 3).should == nil

#     it "negative character values always result in nil", ->
#       # A naive implementation could try to use % 256
#       "hello".index(-(256 - ?e)).should == nil

#     it "starts the search at the given offset", ->
#       "blablabla".index(?b, 0).should == 0
#       "blablabla".index(?b, 1).should == 3
#       "blablabla".index(?b, 2).should == 3
#       "blablabla".index(?b, 3).should == 3
#       "blablabla".index(?b, 4).should == 6
#       "blablabla".index(?b, 5).should == 6
#       "blablabla".index(?b, 6).should == 6

#       "blablabla".index(?a, 0).should == 2
#       "blablabla".index(?a, 2).should == 2
#       "blablabla".index(?a, 3).should == 5
#       "blablabla".index(?a, 4).should == 5
#       "blablabla".index(?a, 5).should == 5
#       "blablabla".index(?a, 6).should == 8
#       "blablabla".index(?a, 7).should == 8
#       "blablabla".index(?a, 8).should == 8

#     it "starts the search at offset + self.length if offset is negative", ->
#       str = "blablabla"

#       [?a, ?b].each do |needle|
#         (-str.length .. -1).each do |offset|
#           str.index(needle, offset).should ==
#           str.index(needle, offset + str.length)

#       "blablabla".index(?b, -9).should == 0

#     it "returns nil if offset + self.length is < 0 for negative offsets", ->
#       "blablabla".index(?b, -10).should == nil
#       "blablabla".index(?b, -20).should == nil

#     it "returns nil if the character isn't found", ->
#       "hello".index(0).should == nil

#       "hello".index(?H).should == nil
#       "hello".index(?z).should == nil
#       "hello".index(?e, 2).should == nil

#       "blablabla".index(?b, 7).should == nil
#       "blablabla".index(?b, 10).should == nil

#       "blablabla".index(?a, 9).should == nil
#       "blablabla".index(?a, 20).should == nil

#     it "converts start_offset to an integer via to_int", ->
#       obj = mock('1')
#       obj.should_receive(:to_int).and_return(1)
#       "ROAR".index(?R, obj).should == 3
#   end