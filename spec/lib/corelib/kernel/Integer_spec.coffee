describe "Kernel#integer", ->
  it "returns a Bignum for a Bignum", ->
    expect( RubyJS.$Integer(2e100) ).toEqual R.$Integer(2e100)

  it "returns a Fixnum for a Fixnum", ->
    expect( RubyJS.$Integer(100) ).toEqual R.$Integer(100)

#   it "uncritically return the value of to_int even if it is not an Integer", ->
#     obj = mock("object")
#     obj.should_receive(:to_int).and_return("1")
#     obj.should_not_receive(:to_i)
#     expect( RubyJS.$Integer(obj) ).toEqual R.$Integer("1")

  describe 'ruby_version_is "1.9"', ->
    it "raises a TypeError when passed nil", ->
      expect( -> RubyJS.$Integer(null) ).toThrow("TypeError")

#   ruby_version_is ""..."1.9", ->
#     it "returns 0 when passed nil", ->
#       expect( RubyJS.$Integer(nil) ).toEqual R.$Integer(0)

#   it "returns a Fixnum or Bignum object", ->
#     Integer(2).should be_an_instance_of(Fixnum)
#     Integer(9**99).should be_an_instance_of(Bignum)

  it "truncates Floats", ->
    expect( RubyJS.$Integer(3.14) ).toEqual R.$Integer( 3)
    expect( RubyJS.$Integer(90.8) ).toEqual R.$Integer(90)

#   it "calls to_i on Rationals", ->
#     expect( RubyJS.$Integer(Rational(8,3)) ).toEqual R.$Integer(2)
#     expect( RubyJS.$Integer(3.quo(2)) ).toEqual R.$Integer(1)

#   it "returns the value of to_int if the result is a Fixnum", ->
#     obj = mock("object")
#     obj.should_receive(:to_int).and_return(1)
#     obj.should_not_receive(:to_i)
#     expect( RubyJS.$Integer(obj) ).toEqual R.$Integer(1)

#   it "returns the value of to_int if the result is a Bignum", ->
#     obj = mock("object")
#     obj.should_receive(:to_int).and_return(2e100)
#     obj.should_not_receive(:to_i)
#     expect( RubyJS.$Integer(obj) ).toEqual R.$Integer(2e100)

#   it "calls to_i on an object whose to_int returns nil", ->
#     obj = mock("object")
#     obj.should_receive(:to_int).and_return(nil)
#     obj.should_receive(:to_i).and_return(1)
#     expect( RubyJS.$Integer(obj) ).toEqual R.$Integer(1)

#   it "uncritically return the value of to_int even if it is not an Integer", ->
#     obj = mock("object")
#     obj.should_receive(:to_int).and_return("1")
#     obj.should_not_receive(:to_i)
#     expect( RubyJS.$Integer(obj) ).toEqual R.$Integer("1")

#   it "raises a TypeError if to_i returns a value that is not an Integer", ->
#     obj = mock("object")
#     obj.should_receive(:to_i).and_return("1")
#     expect( -> RubyJS.$Integer(obj) ).toThrow("TypeError")

#   it "raises a TypeError if no to_int or to_i methods exist", ->
#     obj = mock("object")
#     expect( -> RubyJS.$Integer(obj) ).toThrow("TypeError")

#   it "raises a TypeError if to_int returns nil and no to_i exists", ->
#     obj = mock("object")
#     obj.should_receive(:to_i).and_return(nil)
#     expect( -> RubyJS.$Integer(obj) ).toThrow("TypeError")

#   it "raises a FloatDomainError when passed NaN", ->
#     expect( -> RubyJS.$Integer(nan_value) ).toThrow("FloatDomainError")

#   it "raises a FloatDomainError when passed Infinity", ->
#     expect( -> RubyJS.$Integer(infinity_value) ).toThrow("FloatDomainError")
# end

# describe "Integer() given a String", :shared => true do
#   it "raises an ArgumentError if the String is a null byte", ->
#     expect( -> RubyJS.$Integer("\0") ).toThrow("ArgumentError")

#   it "raises an ArgumentError if the String starts with a null byte", ->
#     expect( -> RubyJS.$Integer("\01") ).toThrow("ArgumentError")

#   it "raises an ArgumentError if the String ends with a null byte", ->
#     expect( -> RubyJS.$Integer("1\0") ).toThrow("ArgumentError")

#   it "raises an ArgumentError if the String contains a null byte", ->
#     expect( -> RubyJS.$Integer("1\01") ).toThrow("ArgumentError")

#   it "ignores leading whitespace", ->
#     expect( RubyJS.$Integer(" 1") ).toEqual R.$Integer(1)
#     expect( RubyJS.$Integer("   1") ).toEqual R.$Integer(1)

  it "ignores trailing whitespace", ->
    expect( RubyJS.$Integer("1 ") ).toEqual R.$Integer(1)
    expect( RubyJS.$Integer("1   ") ).toEqual R.$Integer(1)

  it "raises an ArgumentError if there are leading _s", ->
    expect( -> RubyJS.$Integer("_1") ).toThrow("ArgumentError")
    expect( -> RubyJS.$Integer("___1") ).toThrow("ArgumentError")

  xit "raises an ArgumentError if there are trailing _s", ->
    expect( -> RubyJS.$Integer("1_") ).toThrow("ArgumentError")
    expect( -> RubyJS.$Integer("1___") ).toThrow("ArgumentError")

  it "ignores an embedded _", ->
    expect( RubyJS.$Integer("1_1") ).toEqual R.$Integer(11)

  xit "raises an ArgumentError if there are multiple embedded _s", ->
    expect( -> RubyJS.$Integer("1__1") ).toThrow("ArgumentError")
    expect( -> RubyJS.$Integer("1___1") ).toThrow("ArgumentError")

  it "ignores a single leading +", ->
    expect( RubyJS.$Integer("+1") ).toEqual R.$Integer(1)

  it "raises an ArgumentError if there is a space between the + and number", ->
    expect( -> RubyJS.$Integer("+ 1") ).toThrow("ArgumentError")

  it "raises an ArgumentError if there are multiple leading +s", ->
    expect( -> RubyJS.$Integer("++1") ).toThrow("ArgumentError")
    expect( -> RubyJS.$Integer("+++1") ).toThrow("ArgumentError")

  it "raises an ArgumentError if there are trailing +s", ->
    expect( -> RubyJS.$Integer("1+") ).toThrow("ArgumentError")
    expect( -> RubyJS.$Integer("1+++") ).toThrow("ArgumentError")

  it "makes the number negative if there's a leading -", ->
    expect( RubyJS.$Integer("-1") ).toEqual R.$Integer(-1)

  it "raises an ArgumentError if there are multiple leading -s", ->
    expect( -> RubyJS.$Integer("--1") ).toThrow("ArgumentError")
    expect( -> RubyJS.$Integer("---1") ).toThrow("ArgumentError")

  it "raises an ArgumentError if there are trailing -s", ->
    expect( -> RubyJS.$Integer("1-") ).toThrow("ArgumentError")
    expect( -> RubyJS.$Integer("1---") ).toThrow("ArgumentError")

  xit "raises an ArgumentError if there is a period", ->
    expect( -> RubyJS.$Integer("0.0") ).toThrow("ArgumentError")

  it "raises an ArgumentError for an empty String", ->
    expect( -> RubyJS.$Integer("") ).toThrow("ArgumentError")

#   %w(x X).each do |x|
#     it "parses the value as a hex number if there's a leading 0#{x}", ->
#       expect( RubyJS.$Integer("0#{x}1") ).toEqual R.$Integer(0x1)
#       expect( RubyJS.$Integer("0#{x}dd") ).toEqual R.$Integer(0xdd)

#     it "is a positive hex number if there's a leading +0#{x}", ->
#       expect( RubyJS.$Integer("+0#{x}1") ).toEqual R.$Integer(0x1)
#       expect( RubyJS.$Integer("+0#{x}dd") ).toEqual R.$Integer(0xdd)

#     it "is a negative hex number if there's a leading -0#{x}", ->
#       expect( RubyJS.$Integer("-0#{x}1") ).toEqual R.$Integer(-0x1)
#       expect( RubyJS.$Integer("-0#{x}dd") ).toEqual R.$Integer(-0xdd)

#     it "raises an ArgumentError if the number cannot be parsed as hex", ->
#       expect( -> RubyJS.$Integer("0#{x}g") ).toThrow("ArgumentError")

#   %w(b B).each do |b|
#     it "parses the value as a binary number if there's a leading 0#{b}", ->
#       expect( RubyJS.$Integer("0#{b}1") ).toEqual R.$Integer(0b1)
#       expect( RubyJS.$Integer("0#{b}10") ).toEqual R.$Integer(0b10)

#     it "is a positive binary number if there's a leading +0#{b}", ->
#       expect( RubyJS.$Integer("+0#{b}1") ).toEqual R.$Integer(0b1)
#       expect( RubyJS.$Integer("+0#{b}10") ).toEqual R.$Integer(0b10)

#     it "is a negative binary number if there's a leading -0#{b}", ->
#       expect( RubyJS.$Integer("-0#{b}1") ).toEqual R.$Integer(-0b1)
#       expect( RubyJS.$Integer("-0#{b}10") ).toEqual R.$Integer(-0b10)

#     it "raises an ArgumentError if the number cannot be parsed as binary", ->
#       expect( -> RubyJS.$Integer("0#{b}2") ).toThrow("ArgumentError")

#   ["o", "O", ""].each do |o|
#     it "parses the value as an octal number if there's a leading 0#{o}", ->
#       expect( RubyJS.$Integer("0#{o}1") ).toEqual R.$Integer(0O1)
#       expect( RubyJS.$Integer("0#{o}10") ).toEqual R.$Integer(0O10)

#     it "is a positive octal number if there's a leading +0#{o}", ->
#       expect( RubyJS.$Integer("+0#{o}1") ).toEqual R.$Integer(0O1)
#       expect( RubyJS.$Integer("+0#{o}10") ).toEqual R.$Integer(0O10)

#     it "is a negative octal number if there's a leading -0#{o}", ->
#       expect( RubyJS.$Integer("-0#{o}1") ).toEqual R.$Integer(-0O1)
#       expect( RubyJS.$Integer("-0#{o}10") ).toEqual R.$Integer(-0O10)

#     it "raises an ArgumentError if the number cannot be parsed as octal", ->
#       expect( -> RubyJS.$Integer("0#{o}9") ).toThrow("ArgumentError")

#   %w(D d).each do |d|
#     it "parses the value as a decimal number if there's a leading 0#{d}", ->
#       expect( RubyJS.$Integer("0#{d}1") ).toEqual R.$Integer(1)
#       expect( RubyJS.$Integer("0#{d}10") ).toEqual R.$Integer(10)

#     it "is a positive decimal number if there's a leading +0#{d}", ->
#       expect( RubyJS.$Integer("+0#{d}1") ).toEqual R.$Integer(1)
#       expect( RubyJS.$Integer("+0#{d}10") ).toEqual R.$Integer(10)

#     it "is a negative decimal number if there's a leading -0#{d}", ->
#       expect( RubyJS.$Integer("-0#{d}1") ).toEqual R.$Integer(-1)
#       expect( RubyJS.$Integer("-0#{d}10") ).toEqual R.$Integer(-10)

#     it "raises an ArgumentError if the number cannot be parsed as decimal", ->
#       expect( -> RubyJS.$Integer("0#{d}a") ).toThrow("ArgumentError")
#   end

# describe "Integer() given a String and base", :shared => true do
#   it "raises an ArgumentError if the String is a null byte", ->
#     expect( -> RubyJS.$Integer("\0", 2) ).toThrow("ArgumentError")

#   it "raises an ArgumentError if the String starts with a null byte", ->
#     expect( -> RubyJS.$Integer("\01", 3) ).toThrow("ArgumentError")

#   it "raises an ArgumentError if the String ends with a null byte", ->
#     expect( -> RubyJS.$Integer("1\0", 4) ).toThrow("ArgumentError")

#   it "raises an ArgumentError if the String contains a null byte", ->
#     expect( -> RubyJS.$Integer("1\01", 5) ).toThrow("ArgumentError")

#   it "ignores leading whitespace", ->
#     expect( RubyJS.$Integer(" 16", 16) ).toEqual R.$Integer(22)
#     expect( RubyJS.$Integer("   16", 16) ).toEqual R.$Integer(22)

#   it "ignores trailing whitespace", ->
#     expect( RubyJS.$Integer("16 ", 16) ).toEqual R.$Integer(22)
#     expect( RubyJS.$Integer("16   ", 16) ).toEqual R.$Integer(22)

#   it "raises an ArgumentError if there are leading _s", ->
#     expect( -> RubyJS.$Integer("_1", 7) ).toThrow("ArgumentError")
#     expect( -> RubyJS.$Integer("___1", 7) ).toThrow("ArgumentError")

#   it "raises an ArgumentError if there are trailing _s", ->
#     expect( -> RubyJS.$Integer("1_", 12) ).toThrow("ArgumentError")
#     expect( -> RubyJS.$Integer("1___", 12) ).toThrow("ArgumentError")

#   it "ignores an embedded _", ->
#     expect( RubyJS.$Integer("1_1", 4) ).toEqual R.$Integer(5)

#   it "raises an ArgumentError if there are multiple embedded _s", ->
#     expect( -> RubyJS.$Integer("1__1", 4) ).toThrow("ArgumentError")
#     expect( -> RubyJS.$Integer("1___1", 4) ).toThrow("ArgumentError")

#   it "ignores a single leading +", ->
#     expect( RubyJS.$Integer("+10", 3) ).toEqual R.$Integer(3)

#   it "raises an ArgumentError if there is a space between the + and number", ->
#     expect( -> RubyJS.$Integer("+ 1", 3) ).toThrow("ArgumentError")

#   it "raises an ArgumentError if there are multiple leading +s", ->
#     expect( -> RubyJS.$Integer("++1", 3) ).toThrow("ArgumentError")
#     expect( -> RubyJS.$Integer("+++1", 3) ).toThrow("ArgumentError")

#   it "raises an ArgumentError if there are trailing +s", ->
#     expect( -> RubyJS.$Integer("1+", 3) ).toThrow("ArgumentError")
#     expect( -> RubyJS.$Integer("1+++", 12) ).toThrow("ArgumentError")

#   it "makes the number negative if there's a leading -", ->
#     expect( RubyJS.$Integer("-19", 20) ).toEqual R.$Integer(-29)

#   it "raises an ArgumentError if there are multiple leading -s", ->
#     expect( -> RubyJS.$Integer("--1", 9) ).toThrow("ArgumentError")
#     expect( -> RubyJS.$Integer("---1", 9) ).toThrow("ArgumentError")

#   it "raises an ArgumentError if there are trailing -s", ->
#     expect( -> RubyJS.$Integer("1-", 12) ).toThrow("ArgumentError")
#     expect( -> RubyJS.$Integer("1---", 12) ).toThrow("ArgumentError")

#   it "raises an ArgumentError if there is a period", ->
#     expect( -> RubyJS.$Integer("0.0", 3) ).toThrow("ArgumentError")

#   it "raises an ArgumentError for an empty String", ->
#     expect( -> RubyJS.$Integer("", 12) ).toThrow("ArgumentError")

#   it "raises an ArgumentError for a base of 1", ->
#     expect( -> RubyJS.$Integer("1", 1) ).toThrow("ArgumentError")

#   it "raises an ArgumentError for a base of 37", ->
#     expect( -> RubyJS.$Integer("1", 37) ).toThrow("ArgumentError")

#   it "accepts wholly lowercase alphabetic strings for bases > 10", ->
#     expect( RubyJS.$Integer('ab',12) ).toEqual R.$Integer(131)
#     expect( RubyJS.$Integer('af',20) ).toEqual R.$Integer(215)
#     expect( RubyJS.$Integer('ghj',30) ).toEqual R.$Integer(14929)

#   it "accepts wholly uppercase alphabetic strings for bases > 10", ->
#     expect( RubyJS.$Integer('AB',12) ).toEqual R.$Integer(131)
#     expect( RubyJS.$Integer('AF',20) ).toEqual R.$Integer(215)
#     expect( RubyJS.$Integer('GHJ',30) ).toEqual R.$Integer(14929)

#   it "accepts mixed-case alphabetic strings for bases > 10", ->
#     expect( RubyJS.$Integer('Ab',12) ).toEqual R.$Integer(131)
#     expect( RubyJS.$Integer('aF',20) ).toEqual R.$Integer(215)
#     expect( RubyJS.$Integer('GhJ',30) ).toEqual R.$Integer(14929)

#   it "accepts alphanumeric strings for bases > 10", ->
#     expect( RubyJS.$Integer('a3e',19) ).toEqual R.$Integer(3681)
#     expect( RubyJS.$Integer('12q',31) ).toEqual R.$Integer(1049)
#     expect( RubyJS.$Integer('c00o',29) ).toEqual R.$Integer(292692)

#   it "raises an ArgumentError for letters invalid in the given base", ->
#     expect( -> RubyJS.$Integer('z',19) ).toThrow("ArgumentError")
#     expect( -> RubyJS.$Integer('c00o',2) ).toThrow("ArgumentError")

#   %w(x X).each do |x|
#     it "parses the value as a hex number if there's a leading 0#{x} and a base of 16", ->
#       expect( RubyJS.$Integer("0#{x}10", 16) ).toEqual R.$Integer(16)
#       expect( RubyJS.$Integer("0#{x}dd", 16) ).toEqual R.$Integer(221)

#     it "is a positive hex number if there's a leading +0#{x} and base of 16", ->
#       expect( RubyJS.$Integer("+0#{x}1", 16) ).toEqual R.$Integer(0x1)
#       expect( RubyJS.$Integer("+0#{x}dd", 16) ).toEqual R.$Integer(0xdd)

#     it "is a negative hex number if there's a leading -0#{x} and a base of 16", ->
#       expect( RubyJS.$Integer("-0#{x}1", 16) ).toEqual R.$Integer(-0x1)
#       expect( RubyJS.$Integer("-0#{x}dd", 16) ).toEqual R.$Integer(-0xdd)

#     2.upto(15) do |base|
#       it "raises an ArgumentError if the number begins with 0#{x} and the base is #{base}", ->
#         expect( -> RubyJS.$Integer("0#{x}1", base) ).toThrow("ArgumentError")

#     it "raises an ArgumentError if the number cannot be parsed as hex and the base is 16", ->
#       expect( -> RubyJS.$Integer("0#{x}g", 16) ).toThrow("ArgumentError")

#   %w(b B).each do |b|
#     it "parses the value as a binary number if there's a leading 0#{b} and the base is 2", ->
#       expect( RubyJS.$Integer("0#{b}1", 2) ).toEqual R.$Integer(0b1)
#       expect( RubyJS.$Integer("0#{b}10", 2) ).toEqual R.$Integer(0b10)

#     it "is a positive binary number if there's a leading +0#{b} and a base of 2", ->
#       expect( RubyJS.$Integer("+0#{b}1", 2) ).toEqual R.$Integer(0b1)
#       expect( RubyJS.$Integer("+0#{b}10", 2) ).toEqual R.$Integer(0b10)

#     it "is a negative binary number if there's a leading -0#{b} and a base of 2", ->
#       expect( RubyJS.$Integer("-0#{b}1", 2) ).toEqual R.$Integer(-0b1)
#       expect( RubyJS.$Integer("-0#{b}10", 2) ).toEqual R.$Integer(-0b10)

#     it "raises an ArgumentError if the number cannot be parsed as binary and the base is 2", ->
#       expect( -> RubyJS.$Integer("0#{b}2", 2) ).toThrow("ArgumentError")

#   ["o", "O"].each do |o|
#     it "parses the value as an octal number if there's a leading 0#{o} and a base of 8", ->
#       expect( RubyJS.$Integer("0#{o}1", 8) ).toEqual R.$Integer(0O1)
#       expect( RubyJS.$Integer("0#{o}10", 8) ).toEqual R.$Integer(0O10)

#     it "is a positive octal number if there's a leading +0#{o} and a base of 8", ->
#       expect( RubyJS.$Integer("+0#{o}1", 8) ).toEqual R.$Integer(0O1)
#       expect( RubyJS.$Integer("+0#{o}10", 8) ).toEqual R.$Integer(0O10)

#     it "is a negative octal number if there's a leading -0#{o} and a base of 8", ->
#       expect( RubyJS.$Integer("-0#{o}1", 8) ).toEqual R.$Integer(-0O1)
#       expect( RubyJS.$Integer("-0#{o}10", 8) ).toEqual R.$Integer(-0O10)

#     it "raises an ArgumentError if the number cannot be parsed as octal and the base is 8", ->
#       expect( -> RubyJS.$Integer("0#{o}9", 8) ).toThrow("ArgumentError")

#     2.upto(7) do |base|
#       it "raises an ArgumentError if the number begins with 0#{o} and the base is #{base}", ->
#         expect( -> RubyJS.$Integer("0#{o}1", base) ).toThrow("ArgumentError")

#   %w(D d).each do |d|
#     it "parses the value as a decimal number if there's a leading 0#{d} and a base of 10", ->
#       expect( RubyJS.$Integer("0#{d}1", 10) ).toEqual R.$Integer(1)
#       expect( RubyJS.$Integer("0#{d}10",10) ).toEqual R.$Integer(10)

#     it "is a positive decimal number if there's a leading +0#{d} and a base of 10", ->
#       expect( RubyJS.$Integer("+0#{d}1", 10) ).toEqual R.$Integer(1)
#       expect( RubyJS.$Integer("+0#{d}10", 10) ).toEqual R.$Integer(10)

#     it "is a negative decimal number if there's a leading -0#{d} and a base of 10", ->
#       expect( RubyJS.$Integer("-0#{d}1", 10) ).toEqual R.$Integer(-1)
#       expect( RubyJS.$Integer("-0#{d}10", 10) ).toEqual R.$Integer(-10)

#     it "raises an ArgumentError if the number cannot be parsed as decimal and the base is 10", ->
#       expect( -> RubyJS.$Integer("0#{d}a", 10) ).toThrow("ArgumentError")

#     2.upto(9) do |base|
#       it "raises an ArgumentError if the number begins with 0#{d} and the base is #{base}", ->
#         expect( -> RubyJS.$Integer("0#{d}1", base) ).toThrow("ArgumentError")

#     it "raises an ArgumentError if a base is given for a non-String value", ->
#       expect( -> RubyJS.$Integer(98, 15) ).toThrow("ArgumentError")
#   end
