describe "String#upto", ->
  it "passes successive values, starting at self and ending at other_string, to the block", ->
    a = R []
    R("*+").upto("*3", (s) -> a.push s )
    expect(a.unbox(true)).toEqual ["*+", "*,", "*-", "*.", "*/", "*0", "*1", "*2", "*3"]

  it "calls the block once even when start eqals stop", ->
    a = R []
    R("abc").upto("abc", (s) -> a.push s )
    expect(a.unbox(true)).toEqual ["abc"]

  # This is weird (in 1.8), but MRI behaves like that
  # ruby_version_is '' ... '1.9' do
  #   it "calls block with self even if self is less than stop but stop length is less than self length", ->
	 #   a = []
	 #   R("25").upto("5", (s) -> a.push s )
	 #   a.should == ["25"]
  #   # end

  describe "ruby_version_is '1.9'", ->
    it "doesn't call block with self even if self is less than stop but stop length is less than self length", ->
      a = R []
      R("25").upto("5", (s) -> a.push s )
      expect(a.unbox(true)).toEqual []

  it "doesn't call block if stop is less than self and stop length is less than self length", ->
    a = R []
    R("25").upto("1", (s) -> a.push s )
    expect(a.unbox(true)).toEqual []

  it "doesn't call the block if self is greater than stop", ->
    a = R []
    R("5").upto("2", (s) -> a.push s )
    expect(a.unbox(true)).toEqual []

  it "stops iterating as soon as the current value's character count gets higher than stop's", ->
    a = R []
    R("96").upto("AA", (s) -> a.push s )
    expect(a.unbox(true)).toEqual ["96", "97", "98", "99"]

  it "returns self", ->
    expect( R("abc").upto("abd", ->)    ).toEqual R("abc")
    expect( R("5").upto("2", (i) -> i ) ).toEqual R("5")

  # it "tries to convert other to string using to_str", ->
  #   other = mock('abd')
  #   def other.to_str() "abd" end

  #   a = []
  #   "abc".upto(other) { |s| a << s }
  #   a.should == ["abc", "abd"]

  it "raises a TypeError if other can't be converted to a string", ->
    expect( -> R("abc").upto(123, ->) ).toThrow('TypeError')
    expect( -> R("abc").upto([], ->) ).toThrow('TypeError')


  # ruby_version_is ''...'1.9' do
  #   it "raises a TypeError on symbols", ->
  #     lambda { "abc".upto(:def) { }     }.should raise_error(TypeError)

  #   it "raises a LocalJumpError if other is a string but no block was given", ->
  #     lambda { "abc".upto("def") }.should raise_error(LocalJumpError)

  #   it "uses succ even for single letters", ->
  #     a = []
  #     "9".upto("A"){ |s| a << s}
  #     a.should == ["9"]

  describe "ruby_version_is '1.9'", ->
    xit "does not work with symbols", ->
      # lambda { "a".upto(:c).to_a }.should raise_error(TypeError)

    it "returns an enumerator when no block given", ->
      en = R("aaa").upto("baa", true)
      expect( en.is_enumerator?).toEqual true
      expect( en.to_a().size() ).toEqual R(26)['**'](2)

    # TODO: R("9").upto("A") special case
    xit "uses the ASCII map for single letters", ->
      a = R []
      R("9").upto("A", (s) -> a.push s )
      expect(a.unbox(true)).toEqual ["9", ":", ";", "<", "=", ">", "?", "@", "A"]

  describe "ruby_version_is '1.8.7'", ->
    it "stops before the last value if exclusive", ->
      a = R []
      R("a").upto("d", true, (s) -> a.push s )
      expect(a.unbox(true)).toEqual ["a", "b", "c"]

