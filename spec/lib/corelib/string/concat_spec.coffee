describe "String#concat", ->
  it "concatenates the given argument to self and returns self", ->
    str = R 'hello '
    expect( str.concat('world') is str).toEqual
    expect( str ).toEqual R("hello world")

  it "converts the given argument to a String using to_str", ->
    obj =
      to_str: () ->
    spy = spyOn(obj, 'to_str').andReturn(R('world!'))
    expect( R('hello ').concat(obj) ).toEqual R('hello world!')
    expect( spy ).wasCalled()

  it "raises a TypeError if the given argument can't be converted to a String", ->
    expect( -> R('hello ').concat([])        ).toThrow('TypeError')
    # expect( -> R('hello ').concat(mock('x')) ).toThrow('TypeError')

  # ruby_version_is ""..."1.9", ->
  #   it "raises a TypeError when self is frozen", ->
  #     a = "hello"
  #     a.freeze

  #     lambda { a.concat("")     }.should raise_error(TypeError)
  #     lambda { a.concat("test") }.should raise_error(TypeError)

  # ruby_version_is "1.9", ->
    xit "raises a RuntimeError when self is frozen", ->
      # a = "hello"
      # a.freeze

      # lambda { a.concat("")     }.should raise_error(RuntimeError)
      # lambda { a.concat("test") }.should raise_error(RuntimeError)

  xit "works when given a subclass instance", ->
    # a = "hello"
    # a << StringSpecs::MyString.new(" world")
    # a.should == "hello world"

  xit "taints self if other is tainted", ->
    # "x".concat("".taint).tainted?.should == true
    # "x".concat("y".taint).tainted?.should == true

  # ruby_version_is "1.9", ->
    xit "untrusts self if other is untrusted", ->
      # "x".concat("".untrust).untrusted?.should == true
      # "x".concat("y".untrust).untrusted?.should == true

  describe "with Integer", ->
    # ruby_version_is ""..."1.9", ->
    #   it "concatencates the argument interpreted as an ASCII character", ->
    #     b = 'hello '.concat('world').concat(33)
    #     b.should == "hello world!"
    #     b.concat(0)
    #     b.should == "hello world!\x00"

    #   it "raises a TypeError when the argument is not between 0 and 255", ->
    #     lambda { "".concat(-200)         }.should raise_error(TypeError)
    #     lambda { "".concat(256)          }.should raise_error(TypeError)
    #     lambda { "".concat(bignum_value) }.should raise_error(TypeError)

    describe 'ruby_version_is "1.9"', ->
      it "concatencates the argument interpreted as a codepoint", ->
        expect( R("").concat(33) ).toEqual R("!")

        # b.encode!(Encoding::UTF_8)
        # b.concat(0x203D)
        # b.should == "!\u203D"

      # ruby_bug "#5855", "2.0", ->
      #   it "returns a ASCII-8BIT string if self is US-ASCII and the argument is between 128-255 (inclusive)", ->
      #     a = ("".encode(Encoding::US_ASCII) << 128)
      #     a.encoding.should == Encoding::ASCII_8BIT
      #     a.should == 128.chr

      #     a = ("".encode(Encoding::US_ASCII) << 255)
      #     a.encoding.should == Encoding::ASCII_8BIT
      #     a.should == 255.chr

      xit "raises RangeError if the argument is an invalid codepoint for self's encoding", ->
        # lambda { "".encode(Encoding::US_ASCII) << 256 }.should raise_error(RangeError)
        # lambda { "".encode(Encoding::EUC_JP) << 0x81  }.should raise_error(RangeError)

      it "raises RangeError if the argument is negative", ->
        expect( -> R("").concat(-200)          ).toThrow('RangeError')
        # lambda { "".concat(-bignum_value) }.should raise_error(RangeError)

    it "doesn't call to_int on its argument", ->
      x =
        to_int: () -> throw "should not be called"
      expect( -> R("").concat(x) ).toThrow('TypeError')

    # ruby_version_is ""..."1.9", ->
    #   it "raises a TypeError when self is frozen", ->
    #     a = "hello"
    #     a.freeze

    #     lambda { a.concat(0)  }.should raise_error(TypeError)
    #     lambda { a.concat(33) }.should raise_error(TypeError)

    # ruby_version_is "1.9", ->
      xit "raises a RuntimeError when self is frozen", ->
        # a = "hello"
        # a.freeze

        # lambda { a.concat(0)  }.should raise_error(RuntimeError)
        # lambda { a.concat(33) }.should raise_error(RuntimeError)

# describe :string_concat_encoding, :shared => true do
#   ruby_version_is "1.9", ->
#     describe "when self is in an ASCII-incompatible encoding incompatible with the argument's encoding", ->
#       it "uses self's encoding if both are empty", ->
#         "".encode("UTF-16LE").concat("").encoding.should == Encoding::UTF_16LE

#       it "uses self's encoding if the argument is empty", ->
#         "x".encode("UTF-16LE").concat("").encoding.should == Encoding::UTF_16LE

#       it "uses the argument's encoding if self is empty", ->
#         "".encode("UTF-16LE").concat("x".encode("UTF-8")).encoding.should == Encoding::UTF_8

#       it "raises Encoding::CompatibilityError if neither are empty", ->
#         lambda { "x".encode("UTF-16LE").concat("y".encode("UTF-8")) }.should raise_error(Encoding::CompatibilityError)

#     describe "when the argument is in an ASCII-incompatible encoding incompatible with self's encoding", ->
#       it "uses self's encoding if both are empty", ->
#         "".encode("UTF-8").concat("".encode("UTF-16LE")).encoding.should == Encoding::UTF_8

#       it "uses self's encoding if the argument is empty", ->
#         "x".encode("UTF-8").concat("".encode("UTF-16LE")).encoding.should == Encoding::UTF_8

#       it "uses the argument's encoding if self is empty", ->
#         "".encode("UTF-8").concat("x".encode("UTF-16LE")).encoding.should == Encoding::UTF_16LE

#       it "raises Encoding::CompatibilityError if neither are empty", ->
#         lambda { "x".encode("UTF-8").concat("y".encode("UTF-16LE")) }.should raise_error(Encoding::CompatibilityError)

#     describe "when self and the argument are in different ASCII-compatible encodings", ->
#       it "uses self's encoding if both are ASCII-only", ->
#         "abc".encode("UTF-8").concat("123".encode("SHIFT_JIS")).encoding.should == Encoding::UTF_8

#       it "uses self's encoding if the argument is ASCII-only", ->
#         "\u00E9".encode("UTF-8").concat("123".encode("ISO-8859-1")).encoding.should == Encoding::UTF_8

#       it "uses the argument's encoding if self is ASCII-only", ->
#         "abc".encode("UTF-8").concat("\u00E9".encode("ISO-8859-1")).encoding.should == Encoding::ISO_8859_1

#       it "raises Encoding::CompatibilityError if neither are ASCII-only", ->
#         lambda { "\u00E9".encode("UTF-8").concat("\u00E9".encode("ISO-8859-1")) }.should raise_error(Encoding::CompatibilityError)

#     describe "when self is ASCII-8BIT and argument is US-ASCII", ->
#       it "uses ASCII-8BIT encoding", ->
#         "abc".encode("ASCII-8BIT").concat("123".encode("US-ASCII")).encoding.should == Encoding::ASCII_8BIT
