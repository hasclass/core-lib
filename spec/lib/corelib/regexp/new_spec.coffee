# TODO: tested in Regexp.compile. should have same behaviour.

# describe "Regexp.new", ->
#   # it_behaves_like :regexp_new, :new
#   # -*- encoding: ascii-8bit -*-

#   it "requires one argument and creates a new regular expression object" do
#     Regexp.new('').is_a?(Regexp).should == true

#   it "works by default for subclasses with overridden #initialize" do
#     class RegexpSpecsSubclass < Regexp
#       def initialize(*args)
#         super
#         @args = args

#       attr_accessor :args

#     class RegexpSpecsSubclassTwo < Regexp; end

#     RegexpSpecsSubclass.new("hi").should be_kind_of(RegexpSpecsSubclass)
#     RegexpSpecsSubclass.new("hi").args.first.should == "hi"

#     RegexpSpecsSubclassTwo.new("hi").should be_kind_of(RegexpSpecsSubclassTwo)

# describe :regexp_new_string, :shared => true do
#   it "uses the String argument as an unescaped primitive to construct a Regexp object" do
#     Regexp.new("^hi{2,3}fo.o$").should == /^hi{2,3}fo.o$/

#   it "raises a RegexpError when passed an incorrect regexp" do
#     lambda { Regexp.new("^[$", 0) }.should raise_error(RegexpError)

#   it "does not set Regexp options if only given one argument" do
#     r = Regexp.new('Hi')
#     (r.options & Regexp::IGNORECASE).should     == 0
#     (r.options & Regexp::MULTILINE).should      == 0
#     (r.options & Regexp::EXTENDED).should       == 0

#   it "does not set Regexp options if second argument is nil or false" do
#     r = Regexp.new('Hi', nil)
#     (r.options & Regexp::IGNORECASE).should     == 0
#     (r.options & Regexp::MULTILINE).should      == 0
#     (r.options & Regexp::EXTENDED).should       == 0

#     r = Regexp.new('Hi', false)
#     (r.options & Regexp::IGNORECASE).should     == 0
#     (r.options & Regexp::MULTILINE).should      == 0
#     (r.options & Regexp::EXTENDED).should       == 0

#   it "sets options from second argument if it is one of the Fixnum option constants" do
#     r = Regexp.new('Hi', Regexp::IGNORECASE)
#     (r.options & Regexp::IGNORECASE).should_not == 0
#     (r.options & Regexp::MULTILINE).should      == 0
#     (r.options & Regexp::EXTENDED).should       == 0

#     r = Regexp.new('Hi', Regexp::MULTILINE)
#     (r.options & Regexp::IGNORECASE).should     == 0
#     (r.options & Regexp::MULTILINE).should_not  == 0
#     (r.options & Regexp::EXTENDED).should       == 0

#     r = Regexp.new('Hi', Regexp::EXTENDED)
#     (r.options & Regexp::IGNORECASE).should     == 0
#     (r.options & Regexp::MULTILINE).should      == 0
#     (r.options & Regexp::EXTENDED).should_not   == 1

#   it "accepts a Fixnum of two or more options ORed together as the second argument" do
#     r = Regexp.new('Hi', Regexp::IGNORECASE | Regexp::EXTENDED)
#     (r.options & Regexp::IGNORECASE).should_not == 0
#     (r.options & Regexp::MULTILINE).should      == 0
#     (r.options & Regexp::EXTENDED).should_not   == 0

#   it "treats any non-Fixnum, non-nil, non-false second argument as IGNORECASE" do
#     r = Regexp.new('Hi', Object.new)
#     (r.options & Regexp::IGNORECASE).should_not == 0
#     (r.options & Regexp::MULTILINE).should      == 0
#     (r.options & Regexp::EXTENDED).should       == 0

#   ruby_version_is ""..."1.9" do
#     it "does not enable multibyte support by default" do
#       r = Regexp.send @method, 'Hi', true
#       r.kcode.should_not == 'euc'
#       r.kcode.should_not == 'sjis'
#       r.kcode.should_not == 'utf8'

#     it "enables EUC encoding if third argument is 'e' or 'euc' (case-insensitive)" do
#       Regexp.new('Hi', nil, 'e').kcode.should     == 'euc'
#       Regexp.new('Hi', nil, 'E').kcode.should     == 'euc'
#       Regexp.new('Hi', nil, 'euc').kcode.should   == 'euc'
#       Regexp.new('Hi', nil, 'EUC').kcode.should   == 'euc'
#       Regexp.new('Hi', nil, 'EuC').kcode.should   == 'euc'

#     it "enables SJIS encoding if third argument is 's' or 'sjis' (case-insensitive)" do
#       Regexp.new('Hi', nil, 's').kcode.should     == 'sjis'
#       Regexp.new('Hi', nil, 'S').kcode.should     == 'sjis'
#       Regexp.new('Hi', nil, 'sjis').kcode.should  == 'sjis'
#       Regexp.new('Hi', nil, 'SJIS').kcode.should  == 'sjis'
#       Regexp.new('Hi', nil, 'sJiS').kcode.should  == 'sjis'

#     it "enables UTF-8 encoding if third argument is 'u' or 'utf8' (case-insensitive)" do
#       Regexp.new('Hi', nil, 'u').kcode.should     == 'utf8'
#       Regexp.new('Hi', nil, 'U').kcode.should     == 'utf8'
#       Regexp.new('Hi', nil, 'utf8').kcode.should  == 'utf8'
#       Regexp.new('Hi', nil, 'UTF8').kcode.should  == 'utf8'
#       Regexp.new('Hi', nil, 'uTf8').kcode.should  == 'utf8'

#     it "disables multibyte support if third argument is 'n' or 'none' (case insensitive)" do
#       Regexp.new('Hi', nil, 'N').kcode.should == 'none'
#       Regexp.new('Hi', nil, 'n').kcode.should == 'none'
#       Regexp.new('Hi', nil, 'nONE').kcode.should == 'none'

#   ruby_version_is "1.9" do

#     it "ignores the third argument if it is 'e' or 'euc' (case-insensitive)" do
#       Regexp.new('Hi', nil, 'e').encoding.should    == Encoding::US_ASCII
#       Regexp.new('Hi', nil, 'E').encoding.should    == Encoding::US_ASCII
#       Regexp.new('Hi', nil, 'euc').encoding.should  == Encoding::US_ASCII
#       Regexp.new('Hi', nil, 'EUC').encoding.should  == Encoding::US_ASCII
#       Regexp.new('Hi', nil, 'EuC').encoding.should  == Encoding::US_ASCII

#     it "ignores the third argument if it is 's' or 'sjis' (case-insensitive)" do
#       Regexp.new('Hi', nil, 's').encoding.should     == Encoding::US_ASCII
#       Regexp.new('Hi', nil, 'S').encoding.should     == Encoding::US_ASCII
#       Regexp.new('Hi', nil, 'sjis').encoding.should  == Encoding::US_ASCII
#       Regexp.new('Hi', nil, 'SJIS').encoding.should  == Encoding::US_ASCII
#       Regexp.new('Hi', nil, 'sJiS').encoding.should  == Encoding::US_ASCII

#     it "ignores the third argument if it is 'u' or 'utf8' (case-insensitive)" do
#       Regexp.new('Hi', nil, 'u').encoding.should     == Encoding::US_ASCII
#       Regexp.new('Hi', nil, 'U').encoding.should     == Encoding::US_ASCII
#       Regexp.new('Hi', nil, 'utf8').encoding.should  == Encoding::US_ASCII
#       Regexp.new('Hi', nil, 'UTF8').encoding.should  == Encoding::US_ASCII
#       Regexp.new('Hi', nil, 'uTf8').encoding.should  == Encoding::US_ASCII

#     it "uses US_ASCII encoding if third argument is 'n' or 'none' (case insensitive) and only ascii characters" do
#       Regexp.new('Hi', nil, 'N').encoding.should     == Encoding::US_ASCII
#       Regexp.new('Hi', nil, 'n').encoding.should     == Encoding::US_ASCII
#       Regexp.new('Hi', nil, 'nONE').encoding.should  == Encoding::US_ASCII

#     it "uses ASCII_8BIT encoding if third argument is 'n' or 'none' (case insensitive) and non-ascii characters" do
#       Regexp.new("\xff", nil, 'N').encoding.should     == Encoding::ASCII_8BIT
#       Regexp.new("\xff", nil, 'n').encoding.should     == Encoding::ASCII_8BIT
#       Regexp.new("\xff", nil, 'nONE').encoding.should  == Encoding::ASCII_8BIT


#   describe "with escaped characters" do
#     it "raises a Regexp error if there is a trailing backslash" do
#       lambda { Regexp.new("\\") }.should raise_error(RegexpError)

#     it "accepts a backspace followed by a character" do
#       Regexp.new("\\N").should == /#{"\x5cN"}/

#     it "accepts a one-digit octal value" do
#       Regexp.new("\0").should == /#{"\x00"}/

#     it "accepts a two-digit octal value" do
#       Regexp.new("\11").should == /#{"\x09"}/

#     it "accepts a three-digit octal value" do
#       Regexp.new("\315").should == /#{"\xcd"}/

#     it "interprets a digit following a three-digit octal value as a character" do
#       Regexp.new("\3762").should == /#{"\xfe2"}/

#     it "accepts a one-digit hexadecimal value" do
#       Regexp.new("\x9n").should == /#{"\x09n"}/

#     it "accepts a two-digit hexadecimal value" do
#       Regexp.new("\x23").should == /#{"\x23"}/

#     it "interprets a digit following a two-digit hexadecimal value as a character" do
#       Regexp.new("\x420").should == /#{"\x420"}/

#     ruby_version_is ""..."1.9" do
#       # TODO: Add version argument to compliance guards
#       not_supported_on :rubinius do
#         it "raises a RegexpError if \\x is not followed by any hexadecimal digits" do
#           lambda { Regexp.new("\\" + "xn") }.should raise_error(RegexpError)

#     ruby_version_is "1.9" do
#       it "raises a RegexpError if \\x is not followed by any hexadecimal digits" do
#         lambda { Regexp.new("\\" + "xn") }.should raise_error(RegexpError)

#     it "accepts an escaped string interpolation" do
#       Regexp.new("\#{abc}").should == /#{"\#{abc}"}/

#     it "accepts '\\n'" do
#       Regexp.new("\n").should == /#{"\x0a"}/

#     it "accepts '\\t'" do
#       Regexp.new("\t").should == /#{"\x09"}/

#     it "accepts '\\r'" do
#       Regexp.new("\r").should == /#{"\x0d"}/

#     it "accepts '\\f'" do
#       Regexp.new("\f").should == /#{"\x0c"}/

#     it "accepts '\\v'" do
#       Regexp.new("\v").should == /#{"\x0b"}/

#     it "accepts '\\a'" do
#       Regexp.new("\a").should == /#{"\x07"}/

#     it "accepts '\\e'" do
#       Regexp.new("\e").should == /#{"\x1b"}/

#     it "accepts '\\C-\\n'" do
#       Regexp.new("\C-\n").should == /#{"\x0a"}/

#     it "accepts '\\C-\\t'" do
#       Regexp.new("\C-\t").should == /#{"\x09"}/

#     it "accepts '\\C-\\r'" do
#       Regexp.new("\C-\r").should == /#{"\x0d"}/

#     it "accepts '\\C-\\f'" do
#       Regexp.new("\C-\f").should == /#{"\x0c"}/

#     it "accepts '\\C-\\v'" do
#       Regexp.new("\C-\v").should == /#{"\x0b"}/

#     it "accepts '\\C-\\a'" do
#       Regexp.new("\C-\a").should == /#{"\x07"}/

#     it "accepts '\\C-\\e'" do
#       Regexp.new("\C-\e").should == /#{"\x1b"}/

#     it "accepts '\\c\\n'" do
#       Regexp.new("\C-\n").should == /#{"\x0a"}/

#     it "accepts '\\c\\t'" do
#       Regexp.new("\C-\t").should == /#{"\x09"}/

#     it "accepts '\\c\\r'" do
#       Regexp.new("\C-\r").should == /#{"\x0d"}/

#     it "accepts '\\c\\f'" do
#       Regexp.new("\C-\f").should == /#{"\x0c"}/

#     it "accepts '\\c\\v'" do
#       Regexp.new("\C-\v").should == /#{"\x0b"}/

#     it "accepts '\\c\\a'" do
#       Regexp.new("\C-\a").should == /#{"\x07"}/

#     it "accepts '\\c\\e'" do
#       Regexp.new("\C-\e").should == /#{"\x1b"}/

#     it "accepts '\\M-\\n'" do
#       Regexp.new("\M-\n").should == /#{"\x8a"}/

#     it "accepts '\\M-\\t'" do
#       Regexp.new("\M-\t").should == /#{"\x89"}/

#     it "accepts '\\M-\\r'" do
#       Regexp.new("\M-\r").should == /#{"\x8d"}/

#     it "accepts '\\M-\\f'" do
#       Regexp.new("\M-\f").should == /#{"\x8c"}/

#     it "accepts '\\M-\\v'" do
#       Regexp.new("\M-\v").should == /#{"\x8b"}/

#     it "accepts '\\M-\\a'" do
#       Regexp.new("\M-\a").should == /#{"\x87"}/

#     it "accepts '\\M-\\e'" do
#       Regexp.new("\M-\e").should == /#{"\x9b"}/

#     it "accepts '\\M-\\C-\\n'" do
#       Regexp.new("\M-\n").should == /#{"\x8a"}/

#     it "accepts '\\M-\\C-\\t'" do
#       Regexp.new("\M-\t").should == /#{"\x89"}/

#     it "accepts '\\M-\\C-\\r'" do
#       Regexp.new("\M-\r").should == /#{"\x8d"}/

#     it "accepts '\\M-\\C-\\f'" do
#       Regexp.new("\M-\f").should == /#{"\x8c"}/

#     it "accepts '\\M-\\C-\\v'" do
#       Regexp.new("\M-\v").should == /#{"\x8b"}/

#     it "accepts '\\M-\\C-\\a'" do
#       Regexp.new("\M-\a").should == /#{"\x87"}/

#     it "accepts '\\M-\\C-\\e'" do
#       Regexp.new("\M-\e").should == /#{"\x9b"}/

#     it "accepts '\\M-\\c\\n'" do
#       Regexp.new("\M-\n").should == /#{"\x8a"}/

#     it "accepts '\\M-\\c\\t'" do
#       Regexp.new("\M-\t").should == /#{"\x89"}/

#     it "accepts '\\M-\\c\\r'" do
#       Regexp.new("\M-\r").should == /#{"\x8d"}/

#     it "accepts '\\M-\\c\\f'" do
#       Regexp.new("\M-\f").should == /#{"\x8c"}/

#     it "accepts '\\M-\\c\\v'" do
#       Regexp.new("\M-\v").should == /#{"\x8b"}/

#     it "accepts '\\M-\\c\\a'" do
#       Regexp.new("\M-\a").should == /#{"\x87"}/

#     it "accepts '\\M-\\c\\e'" do
#       Regexp.new("\M-\e").should == /#{"\x9b"}/

#     it "accepts multiple consecutive '\\' characters" do
#       Regexp.new("\\\\\\N").should == /#{"\\\\\\N"}/

#     it "accepts characters and escaped octal digits" do
#       Regexp.new("abc\076").should == /#{"abc\x3e"}/

#     it "accepts escaped octal digits and characters" do
#       Regexp.new("\076abc").should == /#{"\x3eabc"}/

#     it "accepts characters and escaped hexadecimal digits" do
#       Regexp.new("abc\x42").should == /#{"abc\x42"}/

#     it "accepts escaped hexadecimal digits and characters" do
#       Regexp.new("\x3eabc").should == /#{"\x3eabc"}/

#     it "accepts escaped hexadecimal and octal digits" do
#       Regexp.new("\061\x42").should == /#{"\x31\x42"}/

#     ruby_version_is "1.9" do
#       it "accepts \\u{H} for a single Unicode codepoint" do
#         Regexp.new("\u{f}").should == /#{"\x0f"}/

#       it "accepts \\u{HH} for a single Unicode codepoint" do
#         Regexp.new("\u{7f}").should == /#{"\x7f"}/

#       it "accepts \\u{HHH} for a single Unicode codepoint" do
#         Regexp.new("\u{07f}").should == /#{"\x7f"}/

#       it "accepts \\u{HHHH} for a single Unicode codepoint" do
#         Regexp.new("\u{0000}").should == /#{"\x00"}/

#       it "accepts \\u{HHHHH} for a single Unicode codepoint" do
#         Regexp.new("\u{00001}").should == /#{"\x01"}/

#       it "accepts \\u{HHHHHH} for a single Unicode codepoint" do
#         Regexp.new("\u{000000}").should == /#{"\x00"}/

#       it "accepts characters followed by \\u{HHHH}" do
#         Regexp.new("abc\u{3042}").should == /#{"abc\u3042"}/

#       it "accepts \\u{HHHH} followed by characters" do
#         Regexp.new("\u{3042}abc").should == /#{"\u3042abc"}/

#       it "accepts escaped hexadecimal digits followed by \\u{HHHH}" do
#         Regexp.new("\x42\u{3042}").should == /#{"\x42\u3042"}/

#       it "accepts escaped octal digits followed by \\u{HHHH}" do
#         Regexp.new("\056\u{3042}").should == /#{"\x2e\u3042"}/

#       it "accepts a combination of escaped octal and hexadecimal digits and \\u{HHHH}" do
#         Regexp.new("\056\x42\u{3042}\x52\076").should == /#{"\x2e\x42\u3042\x52\x3e"}/

#       it "accepts \\uHHHH for a single Unicode codepoint" do
#         Regexp.new("\u3042").should == /#{"\u3042"}/

#       it "accepts characters followed by \\uHHHH" do
#         Regexp.new("abc\u3042").should == /#{"abc\u3042"}/

#       it "accepts \\uHHHH followed by characters" do
#         Regexp.new("\u3042abc").should == /#{"\u3042abc"}/

#       it "accepts escaped hexadecimal digits followed by \\uHHHH" do
#         Regexp.new("\x42\u3042").should == /#{"\x42\u3042"}/

#       it "accepts escaped octal digits followed by \\uHHHH" do
#         Regexp.new("\056\u3042").should == /#{"\x2e\u3042"}/

#       it "accepts a combination of escaped octal and hexadecimal digits and \\uHHHH" do
#         Regexp.new("\056\x42\u3042\x52\076").should == /#{"\x2e\x42\u3042\x52\x3e"}/

#       it "raises a RegexpError if less than four digits are given for \\uHHHH" do
#         lambda { Regexp.new("\\" + "u304") }.should raise_error(RegexpError)

#       it "raises a RegexpError if the \\u{} escape is empty" do
#         lambda { Regexp.new("\\" + "u{}") }.should raise_error(RegexpError)

#       it "raises a RegexpError if more than six hexadecimal digits are given" do
#         lambda { Regexp.new("\\" + "u{0ffffff}") }.should raise_error(RegexpError)

#       it "returns a Regexp with US-ASCII encoding if only 7-bit ASCII characters are present regardless of the input String's encoding" do
#         Regexp.new("abc").encoding.should == Encoding::US_ASCII

#       it "returns a Regexp with source String having US-ASCII encoding if only 7-bit ASCII characters are present regardless of the input String's encoding" do
#         Regexp.new("abc").source.encoding.should == Encoding::US_ASCII

#       it "returns a Regexp with US-ASCII encoding if UTF-8 escape sequences using only 7-bit ASCII are present" do
#         Regexp.new("\u{61}").encoding.should == Encoding::US_ASCII

#       it "returns a Regexp with source String having US-ASCII encoding if UTF-8 escape sequences using only 7-bit ASCII are present" do
#         Regexp.new("\u{61}").source.encoding.should == Encoding::US_ASCII

#       it "returns a Regexp with UTF-8 encoding if any UTF-8 escape sequences outside 7-bit ASCII are present" do
#         Regexp.new("\u{ff}").encoding.should == Encoding::UTF_8

#       it "returns a Regexp with source String having UTF-8 encoding if any UTF-8 escape sequences outside 7-bit ASCII are present" do
#         Regexp.new("\u{ff}").source.encoding.should == Encoding::UTF_8

#       it "returns a Regexp with the input String's encoding" do
#         str = "\x82\xa0".force_encoding(Encoding::Shift_JIS)
#         Regexp.new(str).encoding.should == Encoding::Shift_JIS

#       it "returns a Regexp with source String having the input String's encoding" do
#         str = "\x82\xa0".force_encoding(Encoding::Shift_JIS)
#         Regexp.new(str).source.encoding.should == Encoding::Shift_JIS
#       end

# describe :regexp_new_regexp, :shared => true do
#   it "uses the argument as a primitive to construct a Regexp object" do
#     Regexp.new(/^hi{2,3}fo.o$/).should == /^hi{2,3}fo.o$/

#   it "preserves any options given in the Regexp primitive" do
#     (Regexp.new(/Hi/i).options & Regexp::IGNORECASE).should_not == 0
#     (Regexp.new(/Hi/m).options & Regexp::MULTILINE).should_not == 0
#     (Regexp.new(/Hi/x).options & Regexp::EXTENDED).should_not == 0

#     r = Regexp.send @method, /Hi/imx
#     (r.options & Regexp::IGNORECASE).should_not == 0
#     (r.options & Regexp::MULTILINE).should_not == 0
#     (r.options & Regexp::EXTENDED).should_not == 0

#     r = Regexp.send @method, /Hi/
#     (r.options & Regexp::IGNORECASE).should == 0
#     (r.options & Regexp::MULTILINE).should == 0
#     (r.options & Regexp::EXTENDED).should == 0

#   it "does not honour options given as additional arguments" do
#     r = Regexp.send @method, /hi/, Regexp::IGNORECASE
#     (r.options & Regexp::IGNORECASE).should == 0

#   ruby_version_is ""..."1.9" do
#     it "does not enable multibyte support by default" do
#       r = Regexp.send @method, /Hi/
#       r.kcode.should_not == 'euc'
#       r.kcode.should_not == 'sjis'
#       r.kcode.should_not == 'utf8'

#     it "enables multibyte support if given in the primitive" do
#       Regexp.new(/Hi/u).kcode.should == 'utf8'
#       Regexp.new(/Hi/e).kcode.should == 'euc'
#       Regexp.new(/Hi/s).kcode.should == 'sjis'
#       Regexp.new(/Hi/n).kcode.should == 'none'

#   ruby_version_is "1.9" do
#     it "sets the encoding to UTF-8 if the Regexp primitive has the 'u' option" do
#       Regexp.new(/Hi/u).encoding.should == Encoding::UTF_8

#     it "sets the encoding to EUC-JP if the Regexp primitive has the 'e' option" do
#       Regexp.new(/Hi/e).encoding.should == Encoding::EUC_JP

#     it "sets the encoding to Windows-31J if the Regexp primitive has the 's' option" do
#       Regexp.new(/Hi/s).encoding.should == Encoding::Windows_31J

#     it "sets the encoding to US-ASCII if the Regexp primitive has the 'n' option and the source String is ASCII only" do
#       Regexp.new(/Hi/n).encoding.should == Encoding::US_ASCII

#     it "sets the encoding to source String's encoding if the Regexp primitive has the 'n' option and the source String is not ASCII only" do
#       Regexp.new(/\xff/n).encoding.should == Encoding::ASCII_8BIT
#   end








# describe "Regexp.new given a String", ->
#   it_behaves_like :regexp_new_string, :new

# describe "Regexp.new given a Regexp", ->
#   it_behaves_like :regexp_new_regexp, :new
