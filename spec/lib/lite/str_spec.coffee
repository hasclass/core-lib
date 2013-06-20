describe '_s', ->
  describe '_s.camel_case', ->
    it 'should leave non-dashed strings alone', ->
      expect( _s.camel_case('foo')   ).toEqual('foo')
      expect( _s.camel_case('')      ).toEqual('')
      expect( _s.camel_case('fooBar')).toEqual('fooBar')


    it 'should covert dash-separated strings to camelCase', ->
      expect( _s.camel_case('foo-bar')    ).toEqual('fooBar')
      expect( _s.camel_case('foo-bar-baz')).toEqual('fooBarBaz')
      expect( _s.camel_case('foo:bar_baz')).toEqual('fooBarBaz')


    xit 'should covert browser specific css properties', ->
      expect( _s.camel_case('-moz-foo-bar')   ).toEqual('MozFooBar')
      expect( _s.camel_case('-webkit-foo-bar')).toEqual('webkitFooBar')
      expect( _s.camel_case('-webkit-foo-bar')).toEqual('webkitFooBar')

describe 'doc-spec', ->
  it '_s.capitalize', ->
    expect( _s.capitalize("hello")   ).toEqual "Hello"
    expect( _s.capitalize("HELLO")   ).toEqual "Hello"
    expect( _s.capitalize("äöü")     ).toEqual "äöü"
    expect( _s.capitalize("123ABC")  ).toEqual "123abc"


  it '_s.center', ->
    expect( _s.center("hello", 4)         ).toEqual "hello"
    expect( _s.center("hello", 20)        ).toEqual "       hello        "
    expect( _s.center("hello", 20, '123') ).toEqual "1231231hello12312312"


  it '_s.chars', ->
    acc = []
    _s.chars("foo", (c) -> acc.push(c + ' ') )
    expect( acc ).toEqual ["f ", "o ", "o "]


  it '_s.chomp', ->
    expect( _s.chomp("hello")          ).toEqual "hello"
    expect( _s.chomp("hello\n")        ).toEqual "hello"
    expect( _s.chomp("hello\r\n")      ).toEqual "hello"
    expect( _s.chomp("hello\n\r")      ).toEqual "hello\n"
    expect( _s.chomp("hello\r")        ).toEqual "hello"
    expect( _s.chomp("hello \n there") ).toEqual "hello \n there"
    expect( _s.chomp("hello", "llo")   ).toEqual "he"


  it '_s.chop', ->
    expect( _s.chop("string\r\n") ).toEqual "string"
    expect( _s.chop("string\n\r") ).toEqual "string\n"
    expect( _s.chop("string\n")   ).toEqual "string"
    expect( _s.chop("string")     ).toEqual "strin"
    expect( _s.chop(_s.chop("x")) ).toEqual ""


  it '_s.count', ->
    str = "hello world"
    expect( _s.count(str, "lo")          ).toEqual 5
    expect( _s.count(str, "lo", "o")     ).toEqual 2
    expect( _s.count(str, "hello", "^l") ).toEqual 4
    expect( _s.count(str, "ej-m")        ).toEqual 4


  it '_s.delete', ->
    expect( _s.delete("hello", "l","lo")     ).toEqual "heo"
    expect( _s.delete("hello", "lo")         ).toEqual "he"
    expect( _s.delete("hello", "aeiou", "^e")).toEqual "hell"
    expect( _s.delete("hello", "ej-m")       ).toEqual "ho"


  it '_s.downcase', ->
    expect( _s.downcase("hEllO") ).toEqual "hello"

  it '_s.each_char', ->
    acc = []
    _s.each_char("foo", (c) -> acc.push(c + ' ') )
    expect( acc ).toEqual ["f ", "o ", "o "]


  it "_s.swap_case", ->
    expect( _s.swapcase("Hello")        ).toEqual "hELLO"
    expect( _s.swapcase("cYbEr_PuNk11") ).toEqual "CyBeR_pUnK11"


  it "_s.index", ->
    expect( _s.index("hello", 'e')           ).toEqual 1
    expect( _s.index("hello", 'lo')          ).toEqual 3
    expect( _s.index("hello", 'a')           ).toEqual null
    expect( _s.index("hello", 'el')          ).toEqual 1
    # expect( _s.index("hello", /[aeiou]/, -3) ).toEqual 4



  it '_s.insert', ->
    expect( _s.insert("abcd",  0, 'X') ).toEqual "Xabcd"
    expect( _s.insert("abcd",  3, 'X') ).toEqual "abcXd"
    expect( _s.insert("abcd",  4, 'X') ).toEqual "abcdX"
    expect( _s.insert("abcd", -3, 'X') ).toEqual "abXcd"
    expect( _s.insert("abcd", -1, 'X') ).toEqual "abcdX"


  it "_s.ljust", ->
    expect( _s.ljust("hello", 4)          ).toEqual "hello"
    expect( _s.ljust("hello", 20)         ).toEqual "hello               "
    expect( _s.ljust("hello", 20, '1234') ).toEqual "hello123412341234123"


  it '_s.lstrip', ->
    expect( _s.lstrip("  hello  ") ).toEqual "hello  "
    expect( _s.lstrip("hello")     ).toEqual "hello"


  it '_s.multiply', ->
    expect( _s.multiply("Ho! ", 3) ).toEqual "Ho! Ho! Ho! "


  it '_s.reverse', ->
    expect( _s.reverse("stressed") ).toEqual "desserts"


  it '_s.rindex', ->
    expect( _s.rindex("hello", 'e')           ).toEqual 1
    expect( _s.rindex("hello", 'l')           ).toEqual 3
    expect( _s.rindex("hello", 'a')           ).toEqual null
    expect( _s.rindex("hello", /[aeiou]/, -2) ).toEqual 1


  it '_s.rjust', ->
    expect( _s.rjust("hello", 4)          ).toEqual "hello"
    expect( _s.rjust("hello", 20)         ).toEqual "               hello"
    expect( _s.rjust("hello", 20, '1234') ).toEqual "123412341234123hello"


  it '_s.rjust', ->
    expect( _s.rpartition("hello", "l")     ).toEqual ["hel", "l", "o"]
    expect( _s.rpartition("hello", "x")     ).toEqual ["", "", "hello"]
    expect( _s.rpartition("hello", "x")     ).toEqual ["", "", "hello"]
    expect( _s.rpartition("hello", "hello") ).toEqual ["", "hello", ""]
    # expect( _s.rpartition("hello", /.l/)    ).toEqual ["he", "ll", "o"]


  it '_s.rjust', ->
    expect( _s.rstrip("  hello  ") ).toEqual "  hello"
    expect( _s.rstrip("hello")     ).toEqual "hello"


  it '_s.scan', ->
    str = "cruel world"
    expect( _s.scan(str, /\w+/)       ).toEqual ["cruel", "world"]
    expect( _s.scan(str, /.../)       ).toEqual ["cru", "el ", "wor"]
    expect( _s.scan(str, /(...)/)     ).toEqual [["cru"], ["el "], ["wor"]]
    expect( _s.scan(str, /(..)(..)/)  ).toEqual [["cr", "ue"], ["l ", "wo"]]
    acc = []
    _s.scan(str, /\w+/, (w) -> acc.push("<<#{w}>>")  )
    expect( acc ).toEqual ["<<cruel>>", "<<world>>"]
    # TODO Resolve
    # acc = []
    # _s.scan(str, /(.)(.)/, (x,y) -> acc.push(x+y) )
    # expect( acc ).toEqual ["cr", 'ue', 'l ', 'wo', 'rl']


  it '_s.squeeze', ->
    expect( _s.squeeze("yellow moon")                ).toEqual "yelow mon"
    expect( _s.squeeze("  now   is  the", " ")       ).toEqual " now is the"
    expect( _s.squeeze("putters shoot balls", "m-z") ).toEqual "puters shot balls"


  it '_s.strip', ->
    expect( _s.strip("    hello    ") ).toEqual "hello"
    expect( _s.strip("\tgoodbye\r\n") ).toEqual "goodbye"


  it '_s.start_with', ->
    expect( _s.start_with("hello", "hell")               ).toEqual true
    expect( _s.start_with("hello", "heaven", "hell")     ).toEqual true
    expect( _s.start_with("hello", "heaven", "paradise") ).toEqual false

  it '_s.start_with', ->
    expect( _s.succ("abcd")      ).toEqual "abce"
    expect( _s.succ("THX1138")   ).toEqual "THX1139"
    expect( _s.succ("<<koala>>") ).toEqual "<<koalb>>"
    expect( _s.succ("1999zzz")   ).toEqual "2000aaa"
    expect( _s.succ("ZZZ9999")   ).toEqual "AAAA0000"
    expect( _s.succ("***")       ).toEqual "**+"