describe "_s", ->
  describe 'camel_case', ->
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


  describe "_s.swap_case", ->
    expect( _s.swapcase("Hello")        ).toEqual "hELLO"
    expect( _s.swapcase("cYbEr_PuNk11") ).toEqual "CyBeR_pUnK11"


  describe '_s.insert', ->
    expect( _s.insert("abcd",  0, 'X') ).toEqual "Xabcd"
    expect( _s.insert("abcd",  3, 'X') ).toEqual "abcXd"
    expect( _s.insert("abcd",  4, 'X') ).toEqual "abcdX"
    expect( _s.insert("abcd", -3, 'X') ).toEqual "abXcd"
    expect( _s.insert("abcd", -1, 'X') ).toEqual "abcdX"


  describe "_s.ljust", ->
    expect( _s.ljust("hello", 4)          ).toEqual "hello"
    expect( _s.ljust("hello", 20)         ).toEqual "hello               "
    expect( _s.ljust("hello", 20, '1234') ).toEqual "hello123412341234123"


  describe '_s.lstrip', ->
    expect( _s.lstrip("  hello  ") ).toEqual "hello  "
    expect( _s.lstrip("hello")     ).toEqual "hello"


  describe '_s.multiply', ->
    expect( _s.multiply("Ho! ", 3) ).toEqual "Ho! Ho! Ho! "


  describe '_s.reverse', ->
    expect( _s.reverse("stressed") ).toEqual "desserts"


  describe '_s.rindex', ->
    expect( _s.rindex("hello", 'e')           ).toEqual 1
    expect( _s.rindex("hello", 'l')           ).toEqual 3
    expect( _s.rindex("hello", 'a')           ).toEqual null
    expect( _s.rindex("hello", /[aeiou]/, -2) ).toEqual 1


  describe '_s.rjust', ->
    expect( _s.rjust("hello", 4)          ).toEqual "hello"
    expect( _s.rjust("hello", 20)         ).toEqual "               hello"
    expect( _s.rjust("hello", 20, '1234') ).toEqual "123412341234123hello"


  describe '_s.rjust', ->
    expect( _s.rpartition("hello", "l")     ).toEqual ["hel", "l", "o"]
    expect( _s.rpartition("hello", "x")     ).toEqual ["", "", "hello"]
    expect( _s.rpartition("hello", "x")     ).toEqual ["", "", "hello"]
    expect( _s.rpartition("hello", "hello") ).toEqual ["", "hello", ""]
    # expect( _s.rpartition("hello", /.l/)    ).toEqual ["he", "ll", "o"]


  describe '_s.rjust', ->
    expect( _s.rstrip("  hello  ") ).toEqual "  hello"
    expect( _s.rstrip("hello")     ).toEqual "hello"


  describe '_s.scan', ->
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


  describe '_s.squeeze', ->
    expect( _s.squeeze("yellow moon")                ).toEqual "yelow mon"
    expect( _s.squeeze("  now   is  the", " ")       ).toEqual " now is the"
    expect( _s.squeeze("putters shoot balls", "m-z") ).toEqual "puters shot balls"


  describe '_s.strip', ->
    expect( _s.strip("    hello    ") ).toEqual "hello"
    expect( _s.strip("\tgoodbye\r\n") ).toEqual "goodbye"


  describe '_s.start_with', ->
    expect( _s.start_with("hello", "hell")               ).toEqual true
    expect( _s.start_with("hello", "heaven", "hell")     ).toEqual true
    expect( _s.start_with("hello", "heaven", "paradise") ).toEqual false

