describe "R.Regexp.compile", ->
  # -*- encoding: ascii-8bit -*-

  describe 'regexp_new', ->
    it "requires one argument and creates a new regular expression object", ->
      expect( R.Regexp.compile('') ).toBeInstanceOf R.Regexp

    xit "works by default for subclasses with overridden #initialize", ->
      # class RegexpSpecsSubclass < Regexp
      #   def initialize(*args)
      #     super
      #     @args = args
      #   attr_accessor :args
      # class RegexpSpecsSubclassTwo < Regexp; end
      # RegexpSpecsSubclass.compile("hi").should be_kind_of(RegexpSpecsSubclass)
      # expect( RegexpSpecsSubclass.compile("hi").args.first ).toEqual "hi"
      # RegexpSpecsSubclassTwo.compile("hi").should be_kind_of(RegexpSpecsSubclassTwo)


  describe 'regexp_new_string', ->
    it "uses the String argument as an unescaped primitive to construct a Regexp object", ->
      expect( R.Regexp.compile("^hi{2,3}fo.o$") ).toEqual R(/^hi{2,3}fo.o$/)

    it "raises a RegexpError when passed an incorrect regexp", ->
      # TODO: not working on opera!
      expect( -> R.Regexp.compile("^[$", 0) ).toThrow('RegexpError')

  #   it "does not set Regexp options if only given one argument", ->
  #     r = R.Regexp.compile('Hi')
  #     (r.options & R.Regexp.IGNORECASE).should     == 0
  #     (r.options & R.Regexp.MULTILINE).should      == 0
  #     (r.options & R.Regexp.EXTENDED).should       == 0

  #   it "does not set Regexp options if second argument is nil or false", ->
  #     r = R.Regexp.compile('Hi', nil)
  #     (r.options & R.Regexp.IGNORECASE).should     == 0
  #     (r.options & R.Regexp.MULTILINE).should      == 0
  #     (r.options & R.Regexp.EXTENDED).should       == 0

  #     r = R.Regexp.compile('Hi', false)
  #     (r.options & R.Regexp.IGNORECASE).should     == 0
  #     (r.options & R.Regexp.MULTILINE).should      == 0
  #     (r.options & R.Regexp.EXTENDED).should       == 0

  #   it "sets options from second argument if it is one of the Fixnum option constants", ->
  #     r = R.Regexp.compile('Hi', R.Regexp.IGNORECASE)
  #     (r.options & R.Regexp.IGNORECASE).should_not == 0
  #     (r.options & R.Regexp.MULTILINE).should      == 0
  #     (r.options & R.Regexp.EXTENDED).should       == 0

  #     r = R.Regexp.compile('Hi', R.Regexp.MULTILINE)
  #     (r.options & R.Regexp.IGNORECASE).should     == 0
  #     (r.options & R.Regexp.MULTILINE).should_not  == 0
  #     (r.options & R.Regexp.EXTENDED).should       == 0

  #     r = R.Regexp.compile('Hi', R.Regexp.EXTENDED)
  #     (r.options & R.Regexp.IGNORECASE).should     == 0
  #     (r.options & R.Regexp.MULTILINE).should      == 0
  #     (r.options & R.Regexp.EXTENDED).should_not   == 1

  #   it "accepts a Fixnum of two or more options ORed together as the second argument", ->
  #     r = R.Regexp.compile('Hi', R.Regexp.IGNORECASE | R.Regexp.EXTENDED)
  #     (r.options & R.Regexp.IGNORECASE).should_not == 0
  #     (r.options & R.Regexp.MULTILINE).should      == 0
  #     (r.options & R.Regexp.EXTENDED).should_not   == 0

  #   it "treats any non-Fixnum, non-nil, non-false second argument as IGNORECASE", ->
  #     r = R.Regexp.compile('Hi', Object.new)
  #     (r.options & R.Regexp.IGNORECASE).should_not == 0
  #     (r.options & R.Regexp.MULTILINE).should      == 0
  #     (r.options & R.Regexp.EXTENDED).should       == 0

  #   # ruby_version_is ""..."1.9", ->
  #   #   it "does not enable multibyte support by default", ->
  #   #     r = R.Regexp.compile 'Hi', true
  #   #     r.kcode.should_not == 'euc'
  #   #     r.kcode.should_not == 'sjis'
  #   #     r.kcode.should_not == 'utf8'

  #   #   it "enables EUC encoding if third argument is 'e' or 'euc' (case-insensitive)", ->
  #   #     R.Regexp.compile('Hi', nil, 'e').kcode.should     == 'euc'
  #   #     R.Regexp.compile('Hi', nil, 'E').kcode.should     == 'euc'
  #   #     R.Regexp.compile('Hi', nil, 'euc').kcode.should   == 'euc'
  #   #     R.Regexp.compile('Hi', nil, 'EUC').kcode.should   == 'euc'
  #   #     R.Regexp.compile('Hi', nil, 'EuC').kcode.should   == 'euc'

  #   #   it "enables SJIS encoding if third argument is 's' or 'sjis' (case-insensitive)", ->
  #   #     R.Regexp.compile('Hi', nil, 's').kcode.should     == 'sjis'
  #   #     R.Regexp.compile('Hi', nil, 'S').kcode.should     == 'sjis'
  #   #     R.Regexp.compile('Hi', nil, 'sjis').kcode.should  == 'sjis'
  #   #     R.Regexp.compile('Hi', nil, 'SJIS').kcode.should  == 'sjis'
  #   #     R.Regexp.compile('Hi', nil, 'sJiS').kcode.should  == 'sjis'

  #   #   it "enables UTF-8 encoding if third argument is 'u' or 'utf8' (case-insensitive)", ->
  #   #     R.Regexp.compile('Hi', nil, 'u').kcode.should     == 'utf8'
  #   #     R.Regexp.compile('Hi', nil, 'U').kcode.should     == 'utf8'
  #   #     R.Regexp.compile('Hi', nil, 'utf8').kcode.should  == 'utf8'
  #   #     R.Regexp.compile('Hi', nil, 'UTF8').kcode.should  == 'utf8'
  #   #     R.Regexp.compile('Hi', nil, 'uTf8').kcode.should  == 'utf8'
  #   #
  #   #   it "disables multibyte support if third argument is 'n' or 'none' (case insensitive)", ->
  #   #     R.Regexp.compile('Hi', nil, 'N').kcode.should == 'none'
  #   #     R.Regexp.compile('Hi', nil, 'n').kcode.should == 'none'
  #   #     R.Regexp.compile('Hi', nil, 'nONE').kcode.should == 'none'
  #   #
  #   # ruby_version_is "1.9", ->
  #   #   it "ignores the third argument if it is 'e' or 'euc' (case-insensitive)", ->
  #   #     R.Regexp.compile('Hi', nil, 'e').encoding.should    == Encoding::US_ASCII
  #   #     R.Regexp.compile('Hi', nil, 'E').encoding.should    == Encoding::US_ASCII
  #   #     R.Regexp.compile('Hi', nil, 'euc').encoding.should  == Encoding::US_ASCII
  #   #     R.Regexp.compile('Hi', nil, 'EUC').encoding.should  == Encoding::US_ASCII
  #   #     R.Regexp.compile('Hi', nil, 'EuC').encoding.should  == Encoding::US_ASCII
  #   #
  #   #   it "ignores the third argument if it is 's' or 'sjis' (case-insensitive)", ->
  #   #     R.Regexp.compile('Hi', nil, 's').encoding.should     == Encoding::US_ASCII
  #   #     R.Regexp.compile('Hi', nil, 'S').encoding.should     == Encoding::US_ASCII
  #   #     R.Regexp.compile('Hi', nil, 'sjis').encoding.should  == Encoding::US_ASCII
  #   #     R.Regexp.compile('Hi', nil, 'SJIS').encoding.should  == Encoding::US_ASCII
  #   #     R.Regexp.compile('Hi', nil, 'sJiS').encoding.should  == Encoding::US_ASCII
  #   #
  #   #   it "ignores the third argument if it is 'u' or 'utf8' (case-insensitive)", ->
  #   #     R.Regexp.compile('Hi', nil, 'u').encoding.should     == Encoding::US_ASCII
  #   #     R.Regexp.compile('Hi', nil, 'U').encoding.should     == Encoding::US_ASCII
  #   #     R.Regexp.compile('Hi', nil, 'utf8').encoding.should  == Encoding::US_ASCII
  #   #     R.Regexp.compile('Hi', nil, 'UTF8').encoding.should  == Encoding::US_ASCII
  #   #     R.Regexp.compile('Hi', nil, 'uTf8').encoding.should  == Encoding::US_ASCII
  #   #
  #   #   it "uses US_ASCII encoding if third argument is 'n' or 'none' (case insensitive) and only ascii characters", ->
  #   #     R.Regexp.compile('Hi', nil, 'N').encoding.should     == Encoding::US_ASCII
  #   #     R.Regexp.compile('Hi', nil, 'n').encoding.should     == Encoding::US_ASCII
  #   #     R.Regexp.compile('Hi', nil, 'nONE').encoding.should  == Encoding::US_ASCII
  #   #
  #   #   it "uses ASCII_8BIT encoding if third argument is 'n' or 'none' (case insensitive) and non-ascii characters", ->
  #   #     R.Regexp.compile("\xff", nil, 'N').encoding.should     == Encoding::ASCII_8BIT
  #   #     R.Regexp.compile("\xff", nil, 'n').encoding.should     == Encoding::ASCII_8BIT
  #   #     R.Regexp.compile("\xff", nil, 'nONE').encoding.should  == Encoding::ASCII_8BIT
  #   #   # end


  describe "with escaped characters", ->
    it "raises a Regexp error if there is a trailing backslash", ->
      expect( -> R.Regexp.compile("\\") ).toThrow('RegexpError')

    xit "accepts a backspace followed by a character", ->
      expect( R.Regexp.compile("\\N") ).toEqual R(/\\N/)

    xit "accepts a one-digit octal value", ->
      # expect( R.Regexp.compile("\0") ).toEqual R(/\x00/)

    xit "accepts a two-digit octal value", ->
      # expect( R.Regexp.compile("\11") ).toEqual R(/\x09/)

    xit "accepts a three-digit octal value", ->
      # expect( R.Regexp.compile("\315") ).toEqual R(/\xcd/)

    xit "interprets a digit following a three-digit octal value as a character", ->
      # expect( R.Regexp.compile("\3762") ).toEqual R(/\xfe2/)

    xit "accepts a one-digit hexadecimal value", ->
      # expect( R.Regexp.compile("\x9n") ).toEqual R(/\x09n/)

    xit "accepts a two-digit hexadecimal value", ->
      # expect( R.Regexp.compile("\x23") ).toEqual R(/\x23/)

    xit "interprets a digit following a two-digit hexadecimal value as a character", ->
      # expect( R.Regexp.compile("\x420") ).toEqual R(/\x420/)

  #   #   ruby_version_is ""..."1.9", ->
  #   #     # TODO: Add version argument to compliance guards
  #   #     not_supported_on :rubinius do
  #   #       it "raises a RegexpError if \\x is not followed by any hexadecimal digits", ->
  #   #         lambda { R.Regexp.compile("\\" + "xn") }.should raise_error(RegexpError)

  #   #   ruby_version_is "1.9", ->
  #   #     it "raises a RegexpError if \\x is not followed by any hexadecimal digits", ->
  #   #       lambda { R.Regexp.compile("\\" + "xn") }.should raise_error(RegexpError)

  #   #   it "accepts an escaped string interpolation", ->
  #   #     R.Regexp.compile("\#{abc}").should == /#{"\#{abc}"}/

    xit "accepts '\\n'", ->
      expect( R.Regexp.compile("\n") ).toEqual R(/\n/)

    xit "accepts '\\t'", ->
      expect( R.Regexp.compile("\t") ).toEqual R(/\t/)

    xit "accepts '\\r'", ->
      expect( R.Regexp.compile("\r") ).toEqual R(/\r/)

    xit "accepts '\\f'", ->
      expect( R.Regexp.compile("\f") ).toEqual R(/\f/)

    xit "accepts '\\v'", ->
      expect( R.Regexp.compile("\v") ).toEqual R(/\v/)

    xit "accepts '\\a'", ->
      expect( R.Regexp.compile("\a") ).toEqual R(/\a/)

  #   #   it "accepts '\\e'", ->
  #   #     R.Regexp.compile("\e").should == /#{"\x1b"}/

  #   #   it "accepts '\\C-\\n'", ->
  #   #     R.Regexp.compile("\C-\n").should == /#{"\x0a"}/

  #   #   it "accepts '\\C-\\t'", ->
  #   #     R.Regexp.compile("\C-\t").should == /#{"\x09"}/

  #   #   it "accepts '\\C-\\r'", ->
  #   #     R.Regexp.compile("\C-\r").should == /#{"\x0d"}/

  #   #   it "accepts '\\C-\\f'", ->
  #   #     R.Regexp.compile("\C-\f").should == /#{"\x0c"}/

  #   #   it "accepts '\\C-\\v'", ->
  #   #     R.Regexp.compile("\C-\v").should == /#{"\x0b"}/

  #   #   it "accepts '\\C-\\a'", ->
  #   #     R.Regexp.compile("\C-\a").should == /#{"\x07"}/

  #   #   it "accepts '\\C-\\e'", ->
  #   #     R.Regexp.compile("\C-\e").should == /#{"\x1b"}/

  #   #   it "accepts '\\c\\n'", ->
  #   #     R.Regexp.compile("\C-\n").should == /#{"\x0a"}/

  #   #   it "accepts '\\c\\t'", ->
  #   #     R.Regexp.compile("\C-\t").should == /#{"\x09"}/

  #   #   it "accepts '\\c\\r'", ->
  #   #     R.Regexp.compile("\C-\r").should == /#{"\x0d"}/

  #   #   it "accepts '\\c\\f'", ->
  #   #     R.Regexp.compile("\C-\f").should == /#{"\x0c"}/

  #   #   it "accepts '\\c\\v'", ->
  #   #     R.Regexp.compile("\C-\v").should == /#{"\x0b"}/

  #   #   it "accepts '\\c\\a'", ->
  #   #     R.Regexp.compile("\C-\a").should == /#{"\x07"}/

  #   #   it "accepts '\\c\\e'", ->
  #   #     R.Regexp.compile("\C-\e").should == /#{"\x1b"}/

  #   #   it "accepts '\\M-\\n'", ->
  #   #     R.Regexp.compile("\M-\n").should == /#{"\x8a"}/

  #   #   it "accepts '\\M-\\t'", ->
  #   #     R.Regexp.compile("\M-\t").should == /#{"\x89"}/

  #   #   it "accepts '\\M-\\r'", ->
  #   #     R.Regexp.compile("\M-\r").should == /#{"\x8d"}/

  #   #   it "accepts '\\M-\\f'", ->
  #   #     R.Regexp.compile("\M-\f").should == /#{"\x8c"}/

  #   #   it "accepts '\\M-\\v'", ->
  #   #     R.Regexp.compile("\M-\v").should == /#{"\x8b"}/

  #   #   it "accepts '\\M-\\a'", ->
  #   #     R.Regexp.compile("\M-\a").should == /#{"\x87"}/

  #   #   it "accepts '\\M-\\e'", ->
  #   #     R.Regexp.compile("\M-\e").should == /#{"\x9b"}/

  #   #   it "accepts '\\M-\\C-\\n'", ->
  #   #     R.Regexp.compile("\M-\n").should == /#{"\x8a"}/

  #   #   it "accepts '\\M-\\C-\\t'", ->
  #   #     R.Regexp.compile("\M-\t").should == /#{"\x89"}/

  #   #   it "accepts '\\M-\\C-\\r'", ->
  #   #     R.Regexp.compile("\M-\r").should == /#{"\x8d"}/

  #   #   it "accepts '\\M-\\C-\\f'", ->
  #   #     R.Regexp.compile("\M-\f").should == /#{"\x8c"}/

  #   #   it "accepts '\\M-\\C-\\v'", ->
  #   #     R.Regexp.compile("\M-\v").should == /#{"\x8b"}/

  #   #   it "accepts '\\M-\\C-\\a'", ->
  #   #     R.Regexp.compile("\M-\a").should == /#{"\x87"}/

  #   #   it "accepts '\\M-\\C-\\e'", ->
  #   #     R.Regexp.compile("\M-\e").should == /#{"\x9b"}/

  #   #   it "accepts '\\M-\\c\\n'", ->
  #   #     R.Regexp.compile("\M-\n").should == /#{"\x8a"}/

  #   #   it "accepts '\\M-\\c\\t'", ->
  #   #     R.Regexp.compile("\M-\t").should == /#{"\x89"}/

  #   #   it "accepts '\\M-\\c\\r'", ->
  #   #     R.Regexp.compile("\M-\r").should == /#{"\x8d"}/

  #   #   it "accepts '\\M-\\c\\f'", ->
  #   #     R.Regexp.compile("\M-\f").should == /#{"\x8c"}/

  #   #   it "accepts '\\M-\\c\\v'", ->
  #   #     R.Regexp.compile("\M-\v").should == /#{"\x8b"}/

  #   #   it "accepts '\\M-\\c\\a'", ->
  #   #     R.Regexp.compile("\M-\a").should == /#{"\x87"}/

  #   #   it "accepts '\\M-\\c\\e'", ->
  #   #     R.Regexp.compile("\M-\e").should == /#{"\x9b"}/

  #   #   it "accepts multiple consecutive '\\' characters", ->
  #   #     R.Regexp.compile("\\\\\\N").should == /#{"\\\\\\N"}/

  #   #   it "accepts characters and escaped octal digits", ->
  #   #     R.Regexp.compile("abc\076").should == /#{"abc\x3e"}/

  #   #   it "accepts escaped octal digits and characters", ->
  #   #     R.Regexp.compile("\076abc").should == /#{"\x3eabc"}/

  #   #   it "accepts characters and escaped hexadecimal digits", ->
  #   #     R.Regexp.compile("abc\x42").should == /#{"abc\x42"}/

  #   #   it "accepts escaped hexadecimal digits and characters", ->
  #   #     R.Regexp.compile("\x3eabc").should == /#{"\x3eabc"}/

  #   #   it "accepts escaped hexadecimal and octal digits", ->
  #   #     R.Regexp.compile("\061\x42").should == /#{"\x31\x42"}/

  #   #   ruby_version_is "1.9", ->
  #   #     it "accepts \\u{H} for a single Unicode codepoint", ->
  #   #       R.Regexp.compile("\u{f}").should == /#{"\x0f"}/

  #   #     it "accepts \\u{HH} for a single Unicode codepoint", ->
  #   #       R.Regexp.compile("\u{7f}").should == /#{"\x7f"}/

  #   #     it "accepts \\u{HHH} for a single Unicode codepoint", ->
  #   #       R.Regexp.compile("\u{07f}").should == /#{"\x7f"}/

  #   #     it "accepts \\u{HHHH} for a single Unicode codepoint", ->
  #   #       R.Regexp.compile("\u{0000}").should == /#{"\x00"}/

  #   #     it "accepts \\u{HHHHH} for a single Unicode codepoint", ->
  #   #       R.Regexp.compile("\u{00001}").should == /#{"\x01"}/

  #   #     it "accepts \\u{HHHHHH} for a single Unicode codepoint", ->
  #   #       R.Regexp.compile("\u{000000}").should == /#{"\x00"}/

  #   #     it "accepts characters followed by \\u{HHHH}", ->
  #   #       R.Regexp.compile("abc\u{3042}").should == /#{"abc\u3042"}/

  #   #     it "accepts \\u{HHHH} followed by characters", ->
  #   #       R.Regexp.compile("\u{3042}abc").should == /#{"\u3042abc"}/

  #   #     it "accepts escaped hexadecimal digits followed by \\u{HHHH}", ->
  #   #       R.Regexp.compile("\x42\u{3042}").should == /#{"\x42\u3042"}/

  #   #     it "accepts escaped octal digits followed by \\u{HHHH}", ->
  #   #       R.Regexp.compile("\056\u{3042}").should == /#{"\x2e\u3042"}/

  #   #     it "accepts a combination of escaped octal and hexadecimal digits and \\u{HHHH}", ->
  #   #       R.Regexp.compile("\056\x42\u{3042}\x52\076").should == /#{"\x2e\x42\u3042\x52\x3e"}/

  #   #     it "accepts \\uHHHH for a single Unicode codepoint", ->
  #   #       R.Regexp.compile("\u3042").should == /#{"\u3042"}/

  #   #     it "accepts characters followed by \\uHHHH", ->
  #   #       R.Regexp.compile("abc\u3042").should == /#{"abc\u3042"}/

  #   #     it "accepts \\uHHHH followed by characters", ->
  #   #       R.Regexp.compile("\u3042abc").should == /#{"\u3042abc"}/

  #   #     it "accepts escaped hexadecimal digits followed by \\uHHHH", ->
  #   #       R.Regexp.compile("\x42\u3042").should == /#{"\x42\u3042"}/

  #   #     it "accepts escaped octal digits followed by \\uHHHH", ->
  #   #       R.Regexp.compile("\056\u3042").should == /#{"\x2e\u3042"}/

  #   #     it "accepts a combination of escaped octal and hexadecimal digits and \\uHHHH", ->
  #   #       R.Regexp.compile("\056\x42\u3042\x52\076").should == /#{"\x2e\x42\u3042\x52\x3e"}/

  #   #     it "raises a RegexpError if less than four digits are given for \\uHHHH", ->
  #   #       lambda { R.Regexp.compile("\\" + "u304") }.should raise_error(RegexpError)

  #   #     it "raises a RegexpError if the \\u{} escape is empty", ->
  #   #       lambda { R.Regexp.compile("\\" + "u{}") }.should raise_error(RegexpError)

  #   #     it "raises a RegexpError if more than six hexadecimal digits are given", ->
  #   #       lambda { R.Regexp.compile("\\" + "u{0ffffff}") }.should raise_error(RegexpError)

  #   #     it "returns a Regexp with US-ASCII encoding if only 7-bit ASCII characters are present regardless of the input String's encoding", ->
  #   #       R.Regexp.compile("abc").encoding.should == Encoding::US_ASCII

  #   #     it "returns a Regexp with source String having US-ASCII encoding if only 7-bit ASCII characters are present regardless of the input String's encoding", ->
  #   #       R.Regexp.compile("abc").source.encoding.should == Encoding::US_ASCII

  #   #     it "returns a Regexp with US-ASCII encoding if UTF-8 escape sequences using only 7-bit ASCII are present", ->
  #   #       R.Regexp.compile("\u{61}").encoding.should == Encoding::US_ASCII

  #   #     it "returns a Regexp with source String having US-ASCII encoding if UTF-8 escape sequences using only 7-bit ASCII are present", ->
  #   #       R.Regexp.compile("\u{61}").source.encoding.should == Encoding::US_ASCII

  #   #     it "returns a Regexp with UTF-8 encoding if any UTF-8 escape sequences outside 7-bit ASCII are present", ->
  #   #       R.Regexp.compile("\u{ff}").encoding.should == Encoding::UTF_8

  #   #     it "returns a Regexp with source String having UTF-8 encoding if any UTF-8 escape sequences outside 7-bit ASCII are present", ->
  #   #       R.Regexp.compile("\u{ff}").source.encoding.should == Encoding::UTF_8

  #   #     it "returns a Regexp with the input String's encoding", ->
  #   #       str = "\x82\xa0".force_encoding(Encoding::Shift_JIS)
  #   #       R.Regexp.compile(str).encoding.should == Encoding::Shift_JIS

  #   #     it "returns a Regexp with source String having the input String's encoding", ->
  #   #       str = "\x82\xa0".force_encoding(Encoding::Shift_JIS)
  #   #       R.Regexp.compile(str).source.encoding.should == Encoding::Shift_JIS

  # describe :regexp_new_regexp, :shared => true do
  #   it "uses the argument as a primitive to construct a Regexp object", ->
  #     R.Regexp.compile(/^hi{2,3}fo.o$/).should == /^hi{2,3}fo.o$/

  #   it "preserves any options given in the Regexp primitive", ->
  #     (R.Regexp.compile(/Hi/i).options & R.Regexp.IGNORECASE).should_not == 0
  #     (R.Regexp.compile(/Hi/m).options & R.Regexp.MULTILINE).should_not == 0
  #     (R.Regexp.compile(/Hi/x).options & R.Regexp.EXTENDED).should_not == 0

  #     r = R.Regexp.compile /Hi/imx
  #     (r.options & R.Regexp.IGNORECASE).should_not == 0
  #     (r.options & R.Regexp.MULTILINE).should_not == 0
  #     (r.options & R.Regexp.EXTENDED).should_not == 0

  #     r = R.Regexp.compile /Hi/
  #     (r.options & R.Regexp.IGNORECASE).should == 0
  #     (r.options & R.Regexp.MULTILINE).should == 0
  #     (r.options & R.Regexp.EXTENDED).should == 0

  #   it "does not honour options given as additional arguments", ->
  #     r = R.Regexp.compile /hi/, R.Regexp.IGNORECASE
  #     (r.options & R.Regexp.IGNORECASE).should == 0

  #   ruby_version_is ""..."1.9", ->
  #     it "does not enable multibyte support by default", ->
  #       r = R.Regexp.compile /Hi/
  #       r.kcode.should_not == 'euc'
  #       r.kcode.should_not == 'sjis'
  #       r.kcode.should_not == 'utf8'

  #     it "enables multibyte support if given in the primitive", ->
  #       R.Regexp.compile(/Hi/u).kcode.should == 'utf8'
  #       R.Regexp.compile(/Hi/e).kcode.should == 'euc'
  #       R.Regexp.compile(/Hi/s).kcode.should == 'sjis'
  #       R.Regexp.compile(/Hi/n).kcode.should == 'none'

  #   ruby_version_is "1.9", ->
  #     it "sets the encoding to UTF-8 if the Regexp primitive has the 'u' option", ->
  #       R.Regexp.compile(/Hi/u).encoding.should == Encoding::UTF_8

  #     it "sets the encoding to EUC-JP if the Regexp primitive has the 'e' option", ->
  #       R.Regexp.compile(/Hi/e).encoding.should == Encoding::EUC_JP

  #     it "sets the encoding to Windows-31J if the Regexp primitive has the 's' option", ->
  #       R.Regexp.compile(/Hi/s).encoding.should == Encoding::Windows_31J

  #     it "sets the encoding to US-ASCII if the Regexp primitive has the 'n' option and the source String is ASCII only", ->
  #       R.Regexp.compile(/Hi/n).encoding.should == Encoding::US_ASCII

  #     it "sets the encoding to source String's encoding if the Regexp primitive has the 'n' option and the source String is not ASCII only", ->
  #       R.Regexp.compile(/\xff/n).encoding.should == Encoding::ASCII_8BIT
