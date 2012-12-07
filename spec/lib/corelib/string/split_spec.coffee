describe "String#split with String", ->

  # before :each do
  #   @kcode = $KCODE
  # end

  # after :each do
  #   $KCODE = @kcode
  # end

  it "returns an array of substrings based on splitting on the given string", ->
    expect( R("mellow yellow").split("ello").unbox(true) ).toEqual ["m", "w y", "w"]

  it "suppresses trailing empty fields when limit isn't given or 0", ->
    expect( R("1,2,,3,4,,").split(',').unbox(true) ).toEqual ["1", "2", "", "3", "4"]
    expect( R("1,2,,3,4,,").split(',', 0).unbox(true) ).toEqual ["1", "2", "", "3", "4"]
    expect( R("  a  b  c\nd  ").split("  ").unbox(true) ).toEqual ["", "a", "b", "c\nd"]
    expect( R("hai").split("hai").unbox(true) ).toEqual []
    expect( R(",").split(",").unbox(true) ).toEqual []
    expect( R(",").split(",", 0).unbox(true) ).toEqual []

  xit "returns an array with one entry if limit is 1: the original string", ->
    expect( R("hai").split("hai", 1).unbox(true) ).toEqual ["hai"]
    expect( R("x.y.z").split(".", 1).unbox(true) ).toEqual ["x.y.z"]
    expect( R("hello world ").split(" ", 1).unbox(true) ).toEqual ["hello world "]
    expect( R("hi!").split("", 1).unbox(true) ).toEqual ["hi!"]

  xit "returns at most limit fields when limit > 1", ->
    expect( R("hai").split("hai", 2).unbox(true) ).toEqual ["", ""]

    expect( R("1,2,,3,4,,").split(',', 2).unbox(true) ).toEqual ["1", "2,,3,4,,"]
    expect( R("1,2,,3,4,,").split(',', 3).unbox(true) ).toEqual ["1", "2", ",3,4,,"]
    expect( R("1,2,,3,4,,").split(',', 4).unbox(true) ).toEqual ["1", "2", "", "3,4,,"]
    expect( R("1,2,,3,4,,").split(',', 5).unbox(true) ).toEqual ["1", "2", "", "3", "4,,"]
    expect( R("1,2,,3,4,,").split(',', 6).unbox(true) ).toEqual ["1", "2", "", "3", "4", ","]

    expect( R("x").split('x', 2).unbox(true) ).toEqual ["", ""]
    expect( R("xx").split('x', 2).unbox(true) ).toEqual ["", "x"]
    expect( R("xx").split('x', 3).unbox(true) ).toEqual ["", "", ""]
    expect( R("xxx").split('x', 2).unbox(true) ).toEqual ["", "xx"]
    expect( R("xxx").split('x', 3).unbox(true) ).toEqual ["", "", "x"]
    expect( R("xxx").split('x', 4).unbox(true) ).toEqual ["", "", "", ""]

  xit "doesn't suppress or limit fields when limit is negative", ->
    expect( R("1,2,,3,4,,").split(',', -1).unbox(true) ).toEqual ["1", "2", "", "3", "4", "", ""]
    expect( R("1,2,,3,4,,").split(',', -5).unbox(true) ).toEqual ["1", "2", "", "3", "4", "", ""]
    expect( R("  a  b  c\nd  ").split("  ", -1).unbox(true) ).toEqual ["", "a", "b", "c\nd", ""]
    expect( R(",").split(",", -1).unbox(true) ).toEqual ["", ""]

#   it "defaults to $; when string isn't given or nil", ->
#     begin
#       old_fs = $;

#       [",", ":", "", "XY", nil].each do |fs|
#         $; = fs

#         ["x,y,z,,,", "1:2:", "aXYbXYcXY", ""].each do |str|
#           expected = str.split(fs || " ")

#           str.split(nil).should == expected
#           str.split.should == expected

#           str.split(nil, -1).should == str.split(fs || " ", -1)
#           str.split(nil, 0).should == str.split(fs || " ", 0)
#           str.split(nil, 2).should == str.split(fs || " ", 2)
#               ensure
#       $; = old_fs

  it "ignores leading and continuous whitespace when string is a single space", ->
    expect( R(" now's  the time  ").split(' ').unbox(true)     ).toEqual ["now's", "the", "time"]

  xit "ignores leading and continuous whitespace when string is a single space with limit", ->
    # expect( R(" now's  the time  ").split(' ', -1).unbox(true) ).toEqual ["now's", "the", "time", ""]
    # expect( R(" now's  the time  ").split(' ', 3).unbox(true)  ).toEqual ["now's", "the", "time  "]

#     "\t\n a\t\tb \n\r\r\nc\v\vd\v ".split(' ').should == ["a", "b", "c", "d"]
#     "a\x00a b".split(' ').should == ["a\x00a", "b"]

  it "splits between characters when its argument is an empty string", ->
    expect( R("hi!").split("").unbox(true) ).toEqual ["h", "i", "!"]

  xit "splits between characters when its argument is an empty string", ->
    # "hi!".split("", -1).should == ["h", "i", "!", ""]
    # "hi!".split("", 2).should == ["h", "i!"]

  it "tries converting its pattern argument to a string via to_str", ->
    obj =
      to_str: -> R("::")

    expect( R("hello::world").split(obj).unbox(true) ).toEqual ["hello", "world"]

  xit "tries converting limit to an integer via to_int", ->
    # obj = mock('2')
    # obj.should_receive(:to_int).and_return(2)

    # "1.2.3.4".split(".", obj).should == ["1", "2.3.4"]

  it "doesn't set $~", ->
    R['$~'] = null
    R("x.y.z").split(".")
    expect(R['$~']).toEqual null

  it "returns subclass instances based on self", ->
    str = new StringSpecs.MyString('foo bar')
    arr = str.split(' ')
    expect( arr.first() ).toBeInstanceOf( StringSpecs.MyString )
    # ["", "x.y.z.", "  x  y  "].each do |str|
    #   ["", ".", " "].each do |pat|
    #     [-1, 0, 1, 2].each do |limit|
    #       StringSpecs::MyString.new(str).split(pat, limit).each do |x|
    #         x.should be_kind_of(StringSpecs::MyString)

    #       str.split(StringSpecs::MyString.new(pat), limit).each do |x|
    #         x.should be_kind_of(String)

#   it "does not call constructor on created subclass instances", ->
#     # can't call should_not_receive on an object that doesn't yet exist
#     # so failure here is signalled by exception, not expectation failure

#     s = StringSpecs::StringWithRaisingConstructor.new('silly:string')
#     s.split(':').first.should == 'silly'

  # it "taints the resulting strings if self is tainted", ->
  #   ["", "x.y.z.", "  x  y  "].each do |str|
  #     ["", ".", " "].each do |pat|
  #       [-1, 0, 1, 2].each do |limit|
  #         str.dup.taint.split(pat).each do |x|
  #           x.tainted?.should == true

  #         str.split(pat.dup.taint).each do |x|
  #           x.tainted?.should == false
  #                   end

describe "String#split with Regexp", ->
  it "divides self on regexp matches", ->
    expect( R(" now's  the time").split(/\ /).unbox(true) ).toEqual ["", "now's", "", "the", "time"]
    expect( R(" x\ny ").split(/\ /).unbox(true)           ).toEqual ["", "x\ny"]
    expect( R("1, 2.34,56, 7").split(/,\s*/).unbox(true) ).toEqual ["1", "2.34", "56", "7"]
    expect( R("1x2X3").split(/x/i).unbox(true)           ).toEqual ["1", "2", "3"]

  xit "treats negative limits as no limit", ->
    # "".split(%r!/+!, -1).should == []

  it "suppresses trailing empty fields when limit isn't given or 0", ->
    expect( R("1,2,,3,4,,").split(/,/).unbox(true)       ).toEqual ["1", "2", "", "3", "4"]
    expect( R("1,2,,3,4,,").split(/,/, 0).unbox(true)    ).toEqual ["1", "2", "", "3", "4"]
    expect( R("  a  b  c\nd  ").split(/\s+/).unbox(true) ).toEqual ["", "a", "b", "c", "d"]
    expect( R("hai").split(/hai/).unbox(true)            ).toEqual []
    expect( R(",").split(/,/).unbox(true)                ).toEqual []
    expect( R(",").split(/,/, 0).unbox(true)             ).toEqual []

#   it "returns an array with one entry if limit is 1: the original string", ->
#     "hai".split(/hai/, 1).should == ["hai"]
#     "xAyBzC".split(/[A-Z]/, 1).should == ["xAyBzC"]
#     "hello world ".split(/\s+/, 1).should == ["hello world "]
#     "hi!".split(//, 1).should == ["hi!"]

#   it "returns at most limit fields when limit > 1", ->
#     "hai".split(/hai/, 2).should == ["", ""]

#     "1,2,,3,4,,".split(/,/, 2).should == ["1", "2,,3,4,,"]
#     "1,2,,3,4,,".split(/,/, 3).should == ["1", "2", ",3,4,,"]
#     "1,2,,3,4,,".split(/,/, 4).should == ["1", "2", "", "3,4,,"]
#     "1,2,,3,4,,".split(/,/, 5).should == ["1", "2", "", "3", "4,,"]
#     "1,2,,3,4,,".split(/,/, 6).should == ["1", "2", "", "3", "4", ","]

#     "x".split(/x/, 2).should == ["", ""]
#     "xx".split(/x/, 2).should == ["", "x"]
#     "xx".split(/x/, 3).should == ["", "", ""]
#     "xxx".split(/x/, 2).should == ["", "xx"]
#     "xxx".split(/x/, 3).should == ["", "", "x"]
#     "xxx".split(/x/, 4).should == ["", "", "", ""]

#   it "doesn't suppress or limit fields when limit is negative", ->
#     "1,2,,3,4,,".split(/,/, -1).should == ["1", "2", "", "3", "4", "", ""]
#     "1,2,,3,4,,".split(/,/, -5).should == ["1", "2", "", "3", "4", "", ""]
#     "  a  b  c\nd  ".split(/\s+/, -1).should == ["", "a", "b", "c", "d", ""]
#     ",".split(/,/, -1).should == ["", ""]

#   it "defaults to $; when regexp isn't given or nil", ->
#     begin
#       old_fs = $;

#       [/,/, /:/, //, /XY/, /./].each do |fs|
#         $; = fs

#         ["x,y,z,,,", "1:2:", "aXYbXYcXY", ""].each do |str|
#           expected = str.split(fs)

#           str.split(nil).should == expected
#           str.split.should == expected

#           str.split(nil, -1).should == str.split(fs, -1)
#           str.split(nil, 0).should == str.split(fs, 0)
#           str.split(nil, 2).should == str.split(fs, 2)
#               ensure
#       $; = old_fs

  it "splits between characters when regexp matches a zero-length string", ->
    expect( R("hello").split(//).unbox(true)         ).toEqual ["h", "e", "l", "l", "o"]
    expect( R("AABCCBAA").split(/(?=B)/).unbox(true) ).toEqual ["AA", "BCC", "BAA"]
    expect( R("hi mom").split(/\s*/).unbox(true)     ).toEqual ["h", "i", "m", "o", "m"]
  xit "splits between characters when regexp matches a zero-length string", ->
    # expect( R("hello").split(//, -1).unbox(true) ).toEqual ["h", "e", "l", "l", "o", ""]
    # expect( R("hello").split(//, 2).unbox(true) ).toEqual ["h", "ello"]
    # "AABCCBAA".split(/(?=B)/, -1).should == ["AA", "BCC", "BAA"]
    # "AABCCBAA".split(/(?=B)/, 2).should == ["AA", "BCCBAA"]

#   it "respects $KCODE when splitting between characters", ->
#     str = "こにちわ"
#     reg = %r!!

#     $KCODE = "utf-8"
#     ary = str.split(reg)
#     ary.size.should == 4
#     ary.should == ["こ", "に", "ち", "わ"]

#   it "respects the encoding of the regexp when splitting between characters", ->
#     str = "\303\202"

#     $KCODE = "a"

#     ary = str.split(//u)
#     ary.size.should == 1
#     ary.should == ["\303\202"]

  it "includes all captures in the result array", ->
    expect( R("hello").split(/(el)/).unbox(true)     ).toEqual ["h", "el", "lo"]
    expect( R("hi!").split(/()/).unbox(true)         ).toEqual ["h", "", "i", "", "!"]
    # expect( R("hi!").split(/()/, -1).unbox(true)     ).toEqual ["h", "", "i", "", "!", "", ""]
    expect( R("hello").split(/((el))()/).unbox(true) ).toEqual ["h", "el", "el", "", "lo"]
    expect( R("AabB").split(/([a-z])+/).unbox(true)  ).toEqual ["A", "b", "B"]

  # TODO:
  xit "does not include non-matching captures in the result array", ->
    expect( R("hello").split(/(el)|(xx)/).unbox(true) ).toEqual ["h", "el", "lo"]

#   it "tries converting limit to an integer via to_int", ->
#     obj = mock('2')
#     obj.should_receive(:to_int).and_return(2)

#     "1.2.3.4".split(".", obj).should == ["1", "2.3.4"]

#   it "returns a type error if limit can't be converted to an integer", ->
#     lambda {"1.2.3.4".split(".", "three")}.should raise_error(TypeError)
#     lambda {"1.2.3.4".split(".", nil)    }.should raise_error(TypeError)

#   it "doesn't set $~", ->
#     $~ = nil
#     "x:y:z".split(/:/)
#     $~.should == nil

  it "returns the original string if no matches are found", ->
    expect( R("foo").split("\n").unbox(true) ).toEqual ["foo"]

#   xit "returns subclass instances based on self", ->
#     # ["", "x:y:z:", "  x  y  "].each do |str|
#     #   [//, /:/, /\s+/].each do |pat|
#     #     [-1, 0, 1, 2].each do |limit|
#     #       StringSpecs::MyString.new(str).split(pat, limit).each do |x|
#     #         x.should be_kind_of(StringSpecs::MyString)

#   xit "does not call constructor on created subclass instances", ->
#     # can't call should_not_receive on an object that doesn't yet exist
#     # so failure here is signalled by exception, not expectation failure

#     # s = StringSpecs::StringWithRaisingConstructor.new('silly:string')
#     # s.split(/:/).first.should == 'silly'

#   # it "taints the resulting strings if self is tainted", ->
#   #   ["", "x:y:z:", "  x  y  "].each do |str|
#   #     [//, /:/, /\s+/].each do |pat|
#   #       [-1, 0, 1, 2].each do |limit|
#   #         str.dup.taint.split(pat, limit).each do |x|
#   #           # See the spec below for why the conditional is here
#   #           x.tainted?.should be_true unless x.empty?

#   # When split is called with a limit of -1, empty fields are not suppressed
#   # and a final empty field is *alawys* created (who knows why). This empty
#   # string is not tainted (again, who knows why) on 1.8 but is on 1.9.
#   # ruby_bug "#", "1.8", ->
#   #   it "taints an empty string if self is tainted", ->
#   #     ":".taint.split(//, -1).last.tainted?.should be_true

#   # it "doesn't taints the resulting strings if the Regexp is tainted", ->
#   #   ["", "x:y:z:", "  x  y  "].each do |str|
#   #     [//, /:/, /\s+/].each do |pat|
#   #       [-1, 0, 1, 2].each do |limit|
#   #         str.split(pat.dup.taint, limit).each do |x|
#   #           x.tainted?.should be_false

#   # ruby_version_is "1.9", ->
#   #   it "returns an ArgumentError if an invalid UTF-8 string is supplied", ->
#   #     broken_str = 'проверка' # in russian, means "test"
#   #     broken_str.force_encoding('binary')
#   #     broken_str.chop!
#   #     broken_str.force_encoding('utf-8')
#   #     lambda{ broken_str.split(/\r\n|\r|\n/) }.should raise_error(ArgumentError)
