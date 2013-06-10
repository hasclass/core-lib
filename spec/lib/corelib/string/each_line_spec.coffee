describe "String#each_line", ->
  # it_behaves_like(:string_each_line, :each_line)


  it "splits using default newline separator when none is specified", ->
    a = []
    R("one\ntwo\r\nthree").each_line (s) -> a.push s.valueOf()
    expect( a ).toEqual ["one\n", "two\r\n", "three"]

    b = []
    R("hello\n\n\nworld").each_line (s) -> b.push s.valueOf()
    expect( b ).toEqual ["hello\n", "\n", "\n", "world"]

    c = []
    R("\n\n\n\n\n").each_line (s) -> c.push s.valueOf()
    expect( c ).toEqual ["\n", "\n", "\n", "\n", "\n"]

  it "splits self using the supplied record separator and passes each substring to the block", ->
    a = []
    R("one\ntwo\r\nthree").each_line("\n", (s) -> a.push s.valueOf())
    expect( a ).toEqual ["one\n", "two\r\n", "three"]

    b = []
    R("hello\nworld").each_line('l', (s) -> b.push s.valueOf())
    expect( b ).toEqual [ "hel", "l", "o\nworl", "d" ]

    c = []
    R("hello\n\n\nworld").each_line("\n", (s) -> c.push s.valueOf())
    expect( c ).toEqual ["hello\n", "\n", "\n", "world"]

  xit "taints substrings that are passed to the block if self is tainted", ->
    # "one\ntwo\r\nthree".taint.each_line (s) -> s.tainted?.should == true
    # "x.y.".each_line(".".taint) (s) -> s.tainted?.should == false

  it "passes self as a whole to the block if the separator is nil", ->
    a = []
    R("one\ntwo\r\nthree").each_line(null, (s) -> a.push s.valueOf())
    expect( a ).toEqual ["one\ntwo\r\nthree"]

  it "yields paragraphs (broken by 2 or more successive neweach_line) when passed ''", ->
    a = []
    R("hello\nworld\n\n\nand\nuniverse\n\n\n\n\n").each_line('', (s) -> a.push s.valueOf())
    a.should == ["hello\nworld\n\n\n", "and\nuniverse\n\n\n\n\n"]

    a = []
    R("hello\nworld\n\n\nand\nuniverse\n\n\n\n\ndog").each_line('', (s) -> a << s.valueOf())
    a.should == ["hello\nworld\n\n\n", "and\nuniverse\n\n\n\n\n", "dog"]

  # TODO: test this beast
  # it "uses $/ as the separator when none is given", ->
  #   R([
  #     "", "x", "x\ny", "x\ry", "x\r\ny", "x\n\r\r\ny",
  #     "hello hullo bello"
  #   ]).each (str) ->
  #     R(["", "llo", "\n", "\r", null]).each do |sep|
  #       try
  #         expected = []
  #         str.each_line(sep) { |x| expected << x }

  #         old_rec_sep, $/ = $/, sep

  #         actual = []
  #         str.each_line { |x| actual << x }

  #         actual.should == expected
  #       catch
  #         $/ = old_rec_sep

  # TODO:
  # it "yields subclass instances for subclasses", ->
  #   a = []
  #   StringSpecs::MyString.new("hello\nworld").each_line { |s| a << s.class }
  #   a.should == [StringSpecs::MyString, StringSpecs::MyString]

  it "returns self", ->
    s = R("hello\nworld")
    expect(s.each_line -> ).toEqual s

  it "tries to convert the separator to a string using to_str", ->
    separator =
      to_str: -> R("l")

    a = []
    R("hello\nworld").each_line(separator, (s) -> a.push s.valueOf())
    expect( a ).toEqual [ "hel", "l", "o\nworl", "d" ]


  describe "ruby_version_is '1.9'", ->
    it "does not care if the string is modified while substituting", ->
      str = R("hello\nworld.")
      out = []
      ret = str.each_line (x) ->
        out.push x.valueOf()
        str.replace("hello\nworld!")

      expect( ret ).toEqual R("hello\nworld!")
      expect( out ).toEqual ["hello\n", "world."]

  it "raises a TypeError when the separator can't be converted to a string", ->
    expect( -> R("hello world").each_line(false, ->) ).toThrow('TypeError')
    expect( -> R("hello world").each_line({}, ->)    ).toThrow('TypeError')


  describe "ruby_version_is '1.9'", ->
    it "accept string separator", ->
      expect( R("hello world").each_line('o').to_a().valueOf() ).toEqual ["hello", " wo", "rld"]

    xit "raises a TypeError when the separator is a symbol", ->
      # lambda { "hello world".each_line(:o).to_a }.should raise_error(TypeError)

  describe 'ruby_version_is "1.8.7"', ->
    it "returns an enumerator when no block given", ->
      en = R("hello world").each_line(' ')
      expect( en ).toBeInstanceOf(R.Enumerator)
      expect( en.to_a().valueOf() ).toEqual ["hello ", "world"]

  # ruby_version_is ''...'1.9' do
  #   it "raises a RuntimeError if the string is modified while substituting", ->
  #     str = "hello\nworld"
  #     lambda { str.each_line { str[0] = 'x' } }.should raise_error(RuntimeError)

  # ruby_version_is ''...'1.9' do
  #   it "raises a TypeError when the separator is a character or a symbol", ->
  #     lambda { "hello world".each_line(?o) {}        }.should raise_error(TypeError)
  #     lambda { "hello world".each_line(:o) {}        }.should raise_error(TypeError)
