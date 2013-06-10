describe "String#scan", ->
  # before :each do
  #   @kcode = $KCODE

  # after :each do
  #   $KCODE = @kcode

  it "returns an array containing all matches", ->
    expect( R("cruel world").scan(/\w+/).valueOf()  ).toEqual ["cruel", "world"]
    expect( R("cruel world").scan(/.../).valueOf()  ).toEqual ["cru", "el ", "wor"]

    # Edge case
    expect( R("hello").scan(//).valueOf() ).toEqual ["", "", "", "", "", ""]
    expect( R("").scan(//).valueOf() ).toEqual [""]

  it "respects $KCODE when the pattern collapses to nothing", ->
    str = "こにちわ"
    reg = //
    # $KCODE = "utf-8"
    expect( R(str).scan(reg).valueOf() ).toEqual ["", "", "", "", ""]

  it "stores groups as arrays in the returned arrays", ->
    expect( R("hello").scan(/()/).valueOf()             ).toEqual [[""],[""],[""],[""],[""],[""]]
    expect( R("hello").scan(/()()/).valueOf()           ).toEqual [["", ""],["", ""],["", ""],["", ""],["", ""],["", ""]]
    expect( R("cruel world").scan(/(...)/).valueOf()    ).toEqual [["cru"], ["el "], ["wor"]]
    expect( R("cruel world").scan(/(..)(..)/).valueOf() ).toEqual [["cr", "ue"], ["l ", "wo"]]

  it "scans for occurrences of the string if pattern is a string", ->
    expect( R("one two one two").scan('one').valueOf() ).toEqual ["one", "one"]
    expect( R("hello.").scan('.').valueOf()            ).toEqual ['.']

  it "sets $~ to MatchData of last match and nil when there's none", ->
    R('hello.').scan(/.(.)/)
    expect( R['$~'][0] ).toEqual 'o.'

    R('hello.').scan(/not/)
    expect( R['$~'] ).toEqual null

    R('hello.').scan('l')
    expect( R['$~'].begin(0) ).toEqual R(3)
    expect( R['$~'][0] ).toEqual 'l'

    R('hello.').scan('not')
    expect( R['$~'] ).toEqual null

  xit "supports \\G which matches the end of the previous match / string start for first match", ->
    # "one two one two".scan(/\G\w+/).should == ["one"]
    # "one two one two".scan(/\G\w+\s*/).should == ["one ", "two ", "one ", "two"]
    # "one two one two".scan(/\G\s*\w+/).should == ["one", " two", " one", " two"]

  it "tries to convert pattern to a string via to_str", ->
    obj =
      to_str: -> R("o")
    expect( R("o_o").scan(obj).valueOf() ).toEqual ["o", "o"]

  it "raises a TypeError if pattern isn't a Regexp and can't be converted to a String", ->
    expect( -> R("cruel world").scan(5)   ).toThrow('TypeError')
    expect( -> R("cruel world").scan([]) ).toThrow('TypeError')
    expect( -> R("cruel world").scan({})  ).toThrow('TypeError')

  # ruby_bug "#4087", "1.9.2.135", ->
  #   it "taints the results if the String argument is tainted", ->
  #     a = "hello hello hello".scan("hello".taint)
  #     a.each { |m| m.tainted?.should be_true }
  # it "taints the results when passed a String argument if self is tainted", ->
  #   a = "hello hello hello".taint.scan("hello")
  #   a.each { |m| m.tainted?.should be_true }
  # it "taints the results if the Regexp argument is tainted", ->
  #   a = "hello".scan(/./.taint)
  #   a.each { |m| m.tainted?.should be_true }
  # it "taints the results when passed a Regexp argument if self is tainted", ->
  #   a = "hello".taint.scan(/./)
  #   a.each { |m| m.tainted?.should be_true }

describe "String#scan with pattern and block", ->
  it "returns self", ->
    s = R("foo")
    expect( s.scan(/./, ->)    ).toEqual(s)
    expect( s.scan(/roar/, ->) ).toEqual(s)

  it "passes each match to the block as one argument: an array", ->
    a = R([])
    R("cruel world").scan(/\w+/, (w) -> a.push(w) )
    expect( a.valueOf() ).toEqual [["cruel"], ["world"]]

  it "passes groups to the block as one argument: an array", ->
    a = R([])
    R("cruel world").scan(/(..)(..)/, (w) -> a.push(w) )
    expect( a.valueOf() ).toEqual [["cr", "ue"], ["l ", "wo"]]

  # TODO
  xit "sets $~ for access from the block", ->
    str = R("hello")

    matches = []
    offsets = []

    # str.scan(/([aeiou])/) do
    #    md = $~
    #    md.string.should == str
    #    matches << md.to_a
    #    offsets << md.offset(0)
    #    str

  #   matches.should == [["e", "e"], ["o", "o"]]
  #   offsets.should == [[1, 2], [4, 5]]

  #   matches = []
  #   offsets = []

  #   str.scan("l") do
  #      md = $~
  #      md.string.should == str
  #      matches << md.to_a
  #      offsets << md.offset(0)
  #      str

  #   matches.should == [["l"], ["l"]]
  #   offsets.should == [[2, 3], [3, 4]]

  # TODO: does not pass. why??
  xit "restores $~ after leaving the block", ->
    R([/./, "l"]).each (pattern) ->
      old_md = null
      R("hello").scan pattern, ->
        old_md = R['$~']
        R("ok").match(/./)
        "x"

      expect( R['$~'][0] ).toEqual old_md[0]
      expect( R['$~'].string ).toEqual "hello"

  it "sets $~ to MatchData of last match and nil when there's none for access from outside", ->
    R('hello.').scan('l', -> 'x')
    expect( R['$~'].begin(0) ).toEqual R(3)
    expect( R['$~'][0] ).toEqual 'l'

    R('hello.').scan('not', -> 'x')
    expect( R['$~'] ).toEqual null

    R('hello.').scan(/.(.)/, -> 'x')
    expect( R['$~'][0] ).toEqual 'o.'

    R('hello.').scan(/not/, -> 'x')
    expect( R['$~'] ).toEqual null


  # ruby_bug "#4087", "1.9.2.135", ->
  #   it "taints the results if the String argument is tainted", ->
  #     "hello hello hello".scan("hello".taint).each { |m| m.tainted?.should be_true }
  # it "taints the results when passed a String argument if self is tainted", ->
  #   "hello hello hello".taint.scan("hello").each { |m| m.tainted?.should be_true }
  # it "taints the results if the Regexp argument is tainted", ->
  #   "hello".scan(/./.taint).each { |m| m.tainted?.should be_true }
  # it "taints the results when passed a Regexp argument if self is tainted", ->
  #   "hello".taint.scan(/./).each { |m| m.tainted?.should be_true }
