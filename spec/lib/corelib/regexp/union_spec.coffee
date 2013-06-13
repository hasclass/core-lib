describe "Regexp.union", ->
  it "returns /(?!)/ when passed no arguments", ->
    expect( R.Regexp.union() ).toEqual R(/(?!)/)

  it "returns a regular expression that will match passed arguments", ->
    expect( R.Regexp.union("penzance") ).toEqual R(/penzance/)
    expect( R.Regexp.union("skiing", "sledding") ).toEqual R(/skiing|sledding/)
    # expect( R.Regexp.union(/dogs/, /cats/i) ).toEqual R(/(?-mix:dogs)|(?i-mx:cats)/)

  it "returns a regular expression that will match passed arguments", ->
    expect( R.Regexp.union("penzance") ).toEqual R(/penzance/)
    expect( R.Regexp.union("skiing", "sledding") ).toEqual R(/skiing|sledding/)
    # expect( R.Regexp.union(/dogs/, /cats/i) ).toEqual R(/(?-mix:dogs)|(?i-mx:cats)/)

  it "parenthises regexp arguments", ->
    expect( R.Regexp.union(/foo/, /bar/) ).toEqual R(/(foo)|(bar)/)

  it "uses to_str to convert arguments (if not Regexp)", ->
    obj =
      to_str: -> R('foo')
    expect( R.Regexp.union(obj, "bar") ).toEqual R(/foo|bar/)

  describe "ruby_version_is '1.8.7'", ->
    it "accepts a single array of patterns as arguments", ->
      # TODO: help
      # expect( R.Regexp.union(["skiing", "sledding"]) ).toEqual R(/skiing|sledding/)

      # TODO: not supported:
      # expect( R.Regexp.union([/dogs/, /cats/i]) ).toEqual R(/(?-mix:dogs)|(?i-mx:cats)/)
      expect( ->
        R.Regexp.union(["skiing", "sledding"], [/dogs/, /cats/i])
      ).toThrow('TypeError')

  # ruby_version_is '' ... '1.9' do
  #   it "propagates the kcode setting to the output Regexp", ->
  #     Regexp.union(/./u, "meow").kcode.should == "utf8"

  #   it "raises ArgumentError if the kcodes conflict", ->
  #     lambda {
  #       Regexp.union(/./u, /./e)
  #     }.should raise_error(ArgumentError)

  # ruby_version_is "1.9", ->
  #   it "returns a Regexp with the encoding of an ASCII-incompatible String argument", ->
  #     Regexp.union("a".encode("UTF-16LE")).encoding.should == Encoding::UTF_16LE

  #   it "returns a Regexp with the encoding of a String containing non-ASCII-compatible characters", ->
  #     Regexp.union("\u00A9".encode("ISO-8859-1")).encoding.should == Encoding::ISO_8859_1

  #   it "returns a Regexp with US-ASCII encoding if all arguments are ASCII-only", ->
  #     Regexp.union("a".encode("UTF-8"), "b".encode("SJIS")).encoding.should == Encoding::US_ASCII

  #   it "returns a Regexp with the encoding of multiple non-conflicting ASCII-incompatible String arguments", ->
  #     Regexp.union("a".encode("UTF-16LE"), "b".encode("UTF-16LE")).encoding.should == Encoding::UTF_16LE

  #   it "returns a Regexp with the encoding of multiple non-conflicting Strings containing non-ASCII-compatible characters", ->
  #     Regexp.union("\u00A9".encode("ISO-8859-1"), "\u00B0".encode("ISO-8859-1")).encoding.should == Encoding::ISO_8859_1

  #   it "returns a Regexp with the encoding of a String containing non-ASCII-compatible characters and another ASCII-only String", ->
  #     Regexp.union("\u00A9".encode("ISO-8859-1"), "a".encode("UTF-8")).encoding.should == Encoding::ISO_8859_1

  #   it "raises ArgumentError if the arguments include conflicting ASCII-incompatible Strings", ->
  #     lambda {
  #       Regexp.union("a".encode("UTF-16LE"), "b".encode("UTF-16BE"))
  #     }.should raise_error(ArgumentError)

  #   it "raises ArgumentError if the arguments include conflicting ASCII-incompatible Regexps", ->
  #     lambda {
  #       Regexp.union(Regexp.new("a".encode("UTF-16LE")),
  #                    Regexp.new("b".encode("UTF-16BE")))
  #     }.should raise_error(ArgumentError)

  #   it "raises ArgumentError if the arguments include conflicting fixed encoding Regexps", ->
  #     lambda {
  #       Regexp.union(Regexp.new("a".encode("UTF-8"),    Regexp::FIXEDENCODING),
  #                    Regexp.new("b".encode("US-ASCII"), Regexp::FIXEDENCODING))
  #     }.should raise_error(ArgumentError)

  #   it "raises ArgumentError if the arguments include a fixed encoding Regexp and a String containing non-ASCII-compatible characters in a different encoding", ->
  #     lambda {
  #       Regexp.union(Regexp.new("a".encode("UTF-8"), Regexp::FIXEDENCODING),
  #                    "\u00A9".encode("ISO-8859-1"))
  #     }.should raise_error(ArgumentError)

  #   it "raises ArgumentError if the arguments include a String containing non-ASCII-compatible characters and a fixed encoding Regexp in a different encoding", ->
  #     lambda {
  #       Regexp.union("\u00A9".encode("ISO-8859-1"),
  #                    Regexp.new("a".encode("UTF-8"), Regexp::FIXEDENCODING))
  #     }.should raise_error(ArgumentError)

  #   it "raises ArgumentError if the arguments include an ASCII-incompatible String and an ASCII-only String", ->
  #     lambda {
  #       Regexp.union("a".encode("UTF-16LE"), "b".encode("UTF-8"))
  #     }.should raise_error(ArgumentError)

  #   it "raises ArgumentError if the arguments include an ASCII-incompatible Regexp and an ASCII-only String", ->
  #     lambda {
  #       Regexp.union(Regexp.new("a".encode("UTF-16LE")), "b".encode("UTF-8"))
  #     }.should raise_error(ArgumentError)

  #   it "raises ArgumentError if the arguments include an ASCII-incompatible String and an ASCII-only Regexp", ->
  #     lambda {
  #       Regexp.union("a".encode("UTF-16LE"), Regexp.new("b".encode("UTF-8")))
  #     }.should raise_error(ArgumentError)

  #   it "raises ArgumentError if the arguments include an ASCII-incompatible Regexp and an ASCII-only Regexp", ->
  #     lambda {
  #       Regexp.union(Regexp.new("a".encode("UTF-16LE")), Regexp.new("b".encode("UTF-8")))
  #     }.should raise_error(ArgumentError)

  #   it "raises ArgumentError if the arguments include an ASCII-incompatible String and a String containing non-ASCII-compatible characters in a different encoding", ->
  #     lambda {
  #       Regexp.union("a".encode("UTF-16LE"), "\u00A9".encode("ISO-8859-1"))
  #     }.should raise_error(ArgumentError)

  #   it "raises ArgumentError if the arguments include an ASCII-incompatible Regexp and a String containing non-ASCII-compatible characters in a different encoding", ->
  #     lambda {
  #       Regexp.union(Regexp.new("a".encode("UTF-16LE")), "\u00A9".encode("ISO-8859-1"))
  #     }.should raise_error(ArgumentError)

  #   it "raises ArgumentError if the arguments include an ASCII-incompatible String and a Regexp containing non-ASCII-compatible characters in a different encoding", ->
  #     lambda {
  #       Regexp.union("a".encode("UTF-16LE"), Regexp.new("\u00A9".encode("ISO-8859-1")))
  #     }.should raise_error(ArgumentError)

  #   it "raises ArgumentError if the arguments include an ASCII-incompatible Regexp and a Regexp containing non-ASCII-compatible characters in a different encoding", ->
  #     lambda {
  #       Regexp.union(Regexp.new("a".encode("UTF-16LE")), Regexp.new("\u00A9".encode("ISO-8859-1")))
  #     }.should raise_error(ArgumentError)

